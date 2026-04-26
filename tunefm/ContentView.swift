//
//  ContentView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isSignedIn {
            MainTabView()
        } else {
            NavigationStack {
                SignInView()
            }
            // render auth stuff if not signed in, otherwise main view
        }
    }
}
