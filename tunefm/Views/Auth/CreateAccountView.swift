//
//  CreateAccountView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//
import SwiftUI
import PhotosUI

struct CreateAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile photo picker
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                if let profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                guard let newItem = newValue else { return }

                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {

                        await MainActor.run {
                            self.imageData = data
                            self.profileImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
            
            // Fields
            TextField("Username", text: $username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.username)
            
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
            
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .autocorrectionDisabled()
                .textContentType(.password)
            
            // Error message
            if let error = authViewModel.createAccountError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Create Account") {
                authViewModel.createAccount(email: email, password: password, username: username, imageData: imageData)
            }
        }
        .padding()
        .navigationTitle("Create Account")
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(AuthViewModel())
}
