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
            // custom profile picture component
            ProfilePhotoPicker(imageData: $imageData, profileImage: $profileImage)
            
            // input fields
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.headline)
                    
                    TextField("user123", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                    
                    TextField("\("example@email.com")", text: $email) // doing this stops it from showing blue somehow
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                        .foregroundStyle(.gray)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)
                    
                    SecureField("**************", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                }
                
                if let error = authViewModel.createAccountError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // create account button
                // will show spinner when pressed
                Button {
                    authViewModel.createAccount(email: email, password: password, username: username, imageData: imageData)
                } label: {
                    Group {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Create Account")
                                .fontWeight(.bold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
        .navigationTitle("Create Account")
        
        Spacer()
    }
}
