//
//  MainTabView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "square.stack")
                }
            DraftsView()
                .tabItem {
                    Label("Drafts", systemImage: "doc.text")
                }
            
            NavigationStack {
                AlbumSearchView()
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle")
            }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}
