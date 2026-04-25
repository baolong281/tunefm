//
//  AuthViewModel.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: AppUser? = nil // we store a reference to our model for user, which includes extra info like username and profile photo
    @Published var isSignedIn: Bool = false
    @Published var signInError: String?
    @Published var createAccountError: String?

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    init() {
        let _ = Auth.auth().addStateDidChangeListener { _, firebaseUser in
            // if signed in populate user object, otherwise set state as signed out
            if let firebaseUser = firebaseUser {
                self.fetchUserProfile(uid: firebaseUser.uid)
            } else {
                self.user = nil
                self.isSignedIn = false
            }
        }
    }

    // grab user doc from firestore and populate AppUser
    private func fetchUserProfile(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            self.user = AppUser(
                uid: uid,
                username: data["username"] as? String ?? "",
                photoBase64: data["photoBase64"] as? String ?? ""
            )
            self.isSignedIn = true
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.signInError = error.localizedDescription
                return
            }
        }
    }

    // create account more complex, we need all the extra info
    // this is not an atomic operation, i.e., we can fail to make the actual user in firebase but thats too compliated for now
    func createAccount(email: String, password: String, username: String, imageData: Data?) {
        guard let imageData else {
            self.createAccountError = "Profile picture required!"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.createAccountError = error.localizedDescription
                return
            }
            guard let uid = result?.user.uid else { return }
            self.uploadProfileAndSaveUser(uid: uid, username: username, imageData: imageData)
        }
    }

    // firebase storage costs money, so we compress <1mb and store as base64 directly in user instead
    private func uploadProfileAndSaveUser(uid: String, username: String, imageData: Data?) {
        var photoBase64 = ""
        
        if let imageData = imageData {
            if let compressed = ImageHelper.compress(imageData) {
                photoBase64 = ImageHelper.toBase64(compressed)
            } else {
                self.createAccountError = "Image is too large, try a different photo (<1MB)"
                self.rollbackUser(uid: uid)
                return
            }
        }
        
        saveUserToFirestore(uid: uid, username: username, photoBase64: photoBase64)
    }
    
    private func saveUserToFirestore(uid: String, username: String, photoBase64: String) {
        // check if username is taken, otherwise make the user
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                self.createAccountError = "Username \(username) already taken!"
                self.rollbackUser(uid: uid)
                return
            }
            
            self.db.collection("users").document(uid).setData([
                "username": username,
                "photoBase64": photoBase64
            ]) { error in
                if let error = error {
                    self.createAccountError = error.localizedDescription
                    self.rollbackUser(uid: uid)
                    return
                }
                self.fetchUserProfile(uid: uid)
            }
        }
    }

    // rollback if stage 2 of account creation fails
    private func rollbackUser(uid: String) {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Rollback failed: \(error.localizedDescription)")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isSignedIn = false
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProfilePhoto(imageData: Data) {
        guard let uid = user?.uid else { return }

        guard let compressed = ImageHelper.compress(imageData) else {
            self.createAccountError = "Image too large to process."
            return
        }
        let photoBase64 = ImageHelper.toBase64(compressed)

        db.collection("users").document(uid).updateData([
            "photoBase64": photoBase64
        ]) { error in
            if let error = error {
                print("Error updating photo: \(error.localizedDescription)")
                return
            }
            
            self.fetchUserProfile(uid: uid)
        }
    }
    
}
