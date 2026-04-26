//
//  FeedViewModel.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import Foundation
import Combine

class FeedViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading: Bool = false

    // fetch the feed
    // property updates occur in main thread to update on the ui
    func fetchFeed() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        do {
            let result = try await FirebaseReviewService.fetchFeed()
            DispatchQueue.main.async {
                self.reviews = result
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            print(error.localizedDescription)
        }
        
    }
}
