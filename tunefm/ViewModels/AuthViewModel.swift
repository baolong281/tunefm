//
//  AuthViewModel.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

// View model handling authentication flows
// will be passed as environment obect so any view has access to this and can get the current user 
class AuthViewModel: ObservableObject {
    @Published var user: AppUser? = nil // we store a reference to our model for user, which includes extra info like username and profile photo
    @Published var isSignedIn: Bool = false
    @Published var signInError: String?
    @Published var createAccountError: String?
    @Published var isLoading: Bool = false // used for signin / sign up views for better ux

    private let db = Firestore.firestore()

    init() {
        let _ = Auth.auth().addStateDidChangeListener { _, firebaseUser in
            // if signed in populate user object, otherwise set state as signed out
            if let firebaseUser = firebaseUser {
                Task {
                    await self.fetchUserProfile(uid: firebaseUser.uid)
                }
            } else {
                DispatchQueue.main.async {
                    self.user = nil
                    self.isSignedIn = false
                }
            }
        }
    }

    // grab user doc from firestore and populate AppUser
    private func fetchUserProfile(uid: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            guard let data = snapshot.data() else { return }
            let user = AppUser(
                uid: uid,
                username: data["username"] as? String ?? "",
                photoBase64: data["photoBase64"] as? String ?? ""
            )
            DispatchQueue.main.async {
                self.user = user
                self.isSignedIn = true
            }
        } catch {
            // this should never happen
            // this function is only ever called when we know there is a valid user with this uid
            print(error.localizedDescription)
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        signInError = nil // reset sign in erorr if they try again
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.signInError = error.localizedDescription
                    return
                }
            }
        } // callback in init should see this event then propagate this change up to the ContentView, then screen will switch
    }

    // create account more complex, we need all the extra info
    // this is not an atomic operation, i.e., we can fail to make the actual user in firebase but thats too compliated for now
    func createAccount(email: String, password: String, username: String, imageData: Data?) {
        self.isLoading = true
        var uid: String? = nil
        guard let imageData = imageData else {
            self.createAccountError = "Profile picture required!"
            self.isLoading = false
            return
        }
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                uid = result.user.uid
                try await self.uploadProfileAndSaveUser(uid: uid!, username: username, imageData: imageData)
                await fetchUserProfile(uid: uid!)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.createAccountError = error.localizedDescription
                    self.isLoading = false
                }
                // only do the rollback if we got pass the create user in firebase step
                if let uid = uid {
                    await self.rollbackUser(uid: uid)
                }
            }
        }
    }

    // firebase storage costs money, so we compress <1mb and store as base64 directly in user instead
    private func uploadProfileAndSaveUser(uid: String, username: String, imageData: Data) async throws {
        guard let compressed = ImageHelper.compress(imageData) else {
            throw AppError.runtimeError("Image too large, needs to be <1mb.")
        }
        
       let photoBase64 = ImageHelper.toBase64(compressed)
       try await saveUserToFirestore(uid: uid, username: username, photoBase64: photoBase64)
    }
    
    private func saveUserToFirestore(uid: String, username: String, photoBase64: String) async throws {
        // check if username is taken, otherwise make the user
        let snapshot = try await db.collection("users").whereField("username", isEqualTo: username).getDocuments()
        if !snapshot.isEmpty {
            throw AppError.runtimeError("Username \(username) is already taken.")
        }
        try await db.collection("users").document(uid).setData([
            "username": username,
            "photoBase64": photoBase64
        ])
    }

    // rollback if stage 2 of account creation fails
    private func rollbackUser(uid: String) async {
        do {
            try await Auth.auth().currentUser?.delete()
        } catch {
            print("Rollback failed: \(error.localizedDescription)")
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
            
            Task {
                await self.fetchUserProfile(uid: uid)
            }
        }
    }
    
}
