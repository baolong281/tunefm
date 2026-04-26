//
//  tunefmApp.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI
import CoreData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct tunefmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel() // Environment state holding auth status / user object
    @StateObject var tabState = TabState() // State for main tab view, holds what tab we are on
    
    init() {
        // change navigation title fonts
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(name: "Baskerville-Bold", size: 34) ?? .systemFont(ofSize: 34, weight: .bold)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(name: "Baskerville-Bold", size: 17) ?? .systemFont(ofSize: 17, weight: .semibold)
        ]
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
                ContentView()
                    .font(.appBody)
                    .tint(.appAccent)
                    .foregroundColor(.appTextPrimary)
                    .preferredColorScheme(.light)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    // inject as environment objects so any subview can use these
                    .environmentObject(authViewModel)
                    .environmentObject(tabState)
        }
    }
}
