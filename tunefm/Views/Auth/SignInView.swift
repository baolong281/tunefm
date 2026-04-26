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
                    .font(.appDisplay)
                    .fontWeight(.bold)
                
                Text("Your musical listening journal.")
                    .font(.appTitle)
            }
            
            // text fields
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.appBodyBold)
                    
                    TextField("\("example@email.com")", text: $email) // stops from showing blue somehow
                        .padding()
                        .background(Color.appField)
                        .foregroundStyle(Color.appTextSecondary)
                        .cornerRadius(25)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.appBodyBold)
                    
                    SecureField("********", text: $password)
                        .padding()
                        .background(Color.appField)
                        .cornerRadius(25)
                        .onSubmit {
                            authViewModel.signIn(email: email, password: password)
                        }
                }
            }

            // if there is an error display at the bottom
            if let error = authViewModel.signInError {
                Text(error)
                    .foregroundColor(.appDestructive)
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
                .background(Color.appAccent)
                .clipShape(Capsule())
            }

            // create account button, segue to CreateAccountView()
            NavigationLink(destination: CreateAccountView()) {
                Text("Create Account")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appSurfaceMuted)
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
        .padding()
    }
}
