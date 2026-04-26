//
//  FeedView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//
import SwiftUI
import Foundation

// main feed view, will be the first thing we see
struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // main scrollable feed
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.reviews) { review in
                                ReviewCardView(review: review, showUser: true)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            // show tune.fm at the top
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("tune.fm")
                        .font(.appTitle)
                        .fontWeight(.bold)
                }
            }
        }
        // refresh the feed everytime this loads
        .onAppear {
            Task {
                await viewModel.fetchFeed()
            }
        }
    }
}
