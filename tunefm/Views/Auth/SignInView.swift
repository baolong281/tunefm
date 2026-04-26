//
//  SignInView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

// note we are in navigation stack from the ContentView
struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // header
            VStack (alignment: .leading, spacing: 12) {
                Text("tune.fm")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your musical listening journal.")
                    .font(.title3)
            }
            
            // text fields
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                    
                    TextField("\("example@email.com")", text: $email) // stops from showing blue somehow
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundStyle(.gray)
                        .cornerRadius(25)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)
                    
                    SecureField("********", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                        .onSubmit {
                            authViewModel.signIn(email: email, password: password)
                        }
                }
            }

            // if there is an error display at the bottom
            if let error = authViewModel.signInError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button {
                authViewModel.signIn(email: email, password: password)
            } label: {
                Group { // need this so entire button is tappable instead of just label
                    // when pressed / loading show spinner so user knows something is happening
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(Capsule())
            }

            // create account button, segue to CreateAccountView()
            NavigationLink(destination: CreateAccountView()) {
                Text("Create Account")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
        .padding()
    }
}
