//
//  FeedView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//
import SwiftUI
import Foundation

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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("tune.fm")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            viewModel.fetchFeed()
        }
        .onDisappear {
            viewModel.fetchFeed()
        }
    }
}
