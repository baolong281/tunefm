//
//  SignInView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showCreateAccount = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack {
                Text("tune.fm")
                Text("Your musical listening journal.")
            }
            
            // Fields
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                
            SecureField("Password", text: $password)
                .autocorrectionDisabled()
                .textContentType(.password)

            
            // Error message
            if let error = authViewModel.signInError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            // Actions
            Button("Sign In") {
                authViewModel.signIn(email: email, password: password)
            }
            
            Button("Create Account") {
                showCreateAccount = true
            }
        }
        .padding()
        .navigationDestination(isPresented: $showCreateAccount) {
            CreateAccountView()
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
   
}
