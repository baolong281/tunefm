//
//  MainTabView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI
import Combine

// main view will four tabs for feeds, drafts, creating, and profiles
// will be used by CreateReviewView to switch to either draft view or feed view after posting
// we inject this as environment object so we can use this anywhere
class TabState: ObservableObject {
    @Published var selectedTab: Int = 0
    func switchToFeed() { selectedTab = 0 }
    func switchToDrafts() { selectedTab = 1 }
}

struct MainTabView: View {
    @EnvironmentObject var tabState: TabState

    var body: some View {
        TabView (selection: $tabState.selectedTab) {
            FeedView()
            .tabItem {
                Label("Feed", systemImage: "square.stack")
            }
            .tag(0)
            
            DraftsView()
            .tabItem {
                Label("Drafts", systemImage: "doc.text")
            }
            .tag(1)
            
            NavigationStack {
                AlbumSearchView()
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle")
            }
            .tag(3)
            

            ProfileView()
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(4)
        }
    }
}
