//
//  ProfileViewModel.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation
import FirebaseFirestore
import Combine

class ProfileViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading: Bool = false
    @Published var error: String = ""

    private let db = Firestore.firestore()

    func fetchReviews(for uid: String) {
        isLoading = true
        db.collection("reviews")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                self.reviews = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Review.self)
                } ?? []
            }
    }

    func deleteReview(_ review: Review) {
        guard let id = review.id else { return }
        db.collection("reviews").document(id).delete { error in
            if let error = error {
                self.error = error.localizedDescription
            }
        }
    }
}
