//
//  FirebaseReviewService.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import Foundation
import FirebaseFirestore
import Combine

class CreateReviewViewModel: ObservableObject {
    @Published var rating: Double = 0
    @Published var reviewText: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String = ""
    @Published var didFinish: Bool = false

    let album: Album

    private let existingDraft: Draft?

    init(album: Album, existingDraft: Draft? = nil) {
        self.album = album
        self.existingDraft = existingDraft

        if let draft = existingDraft {
            self.rating = draft.rating
            self.reviewText = draft.reviewText
        }
    }

    func postReview(uid: String, username: String, userPhotoBase64: String) {
        isLoading = true
        let review = Review(
            uid: uid,
            username: username,
            userPhotoBase64: userPhotoBase64,
            albumName: album.collectionName,
            artist: album.artistName,
            artworkURL: album.artworkUrl100,
            releaseDate: album.releaseDate,
            rating: rating,
            reviewText: reviewText,
            timestamp: Date()
        )
        Task {
            do {
                try await FirebaseReviewService.postReview(review)
                if let draft = existingDraft {
                    DraftService.deleteDraft(draft)
                }
                didFinish = true
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    func saveDraft() {
        if let existing = existingDraft {
            DraftService.updateDraft(existing, rating: rating, reviewText: reviewText)
        } else {
            DraftService.saveDraft(album: album, rating: rating, reviewText: reviewText)
        }
        didFinish = true
    }
}
