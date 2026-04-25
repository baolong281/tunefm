//
//  SettingsView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @AppStorage("showReleaseDate") var showReleaseDate: Bool = true
    @AppStorage("showStars") var showStars: Bool = true
    
    @State private var showSignOutConfirmation = false
    
    var body: some View {
        List {
            Section {
                Toggle("Show Album Release Date", isOn: $showReleaseDate)
                Toggle("Show Review Stars", isOn: $showStars)
            }
            
            Section {
                Button("Sign Out") {
                    showSignOutConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sign Out", isPresented: $showSignOutConfirmation) {
            Button("Sign Out", role: .destructive) {
                authViewModel.signOut()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
