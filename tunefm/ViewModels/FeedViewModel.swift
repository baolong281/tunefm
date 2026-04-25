//
//  FeedViewModel.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import Foundation
import Combine

@MainActor
class FeedViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading: Bool = false
    @Published var error: String = ""

    func fetchFeed() {
        isLoading = true
        Task {
            do {
                reviews = try await FirebaseReviewService.fetchFeed()
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
}
