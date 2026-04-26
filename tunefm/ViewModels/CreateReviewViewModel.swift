//
//  FirebaseReviewService.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI

// Encapsulates logic for posting reviews
// This can be either loaded (brand new) or pre-initalized from a draft
// if brand new we call CreateReviewViewModel(album: album)
// if initializing from a draft we call CreateReviewViewModel(album: album, draft: draft)

class CreateReviewViewModel: ObservableObject {
    let album: Album
    private let existingDraft: Draft?
    
    // review content, includes rating text if its posting etc...
    @Published var rating: Double = 0
    @Published var reviewText: String = ""
    @Published var error: String?
    @Published var didFinish: Bool = false
    @Published var isLoading: Bool = false


    // if we include the draft then we prefill the content with stuff from the draft
    init(album: Album, existingDraft: Draft? = nil) {
        self.album = album
        self.existingDraft = existingDraft

        if let draft = existingDraft {
            self.rating = draft.rating
            self.reviewText = draft.reviewText
        }
    }

    // post the review to firebase
    // if this was made from a draft then we use the draft service to delete it
    // returns false if posted or not, true otherwise
    func postReview(uid: String, username: String, userPhotoBase64: String) async -> Bool {
        isLoading = true
        
        if reviewText.count >= 240 {
            error = "Review too long! Must be less <240 characters!"
            return false
        }
        
        // create our review object
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
        do {
            try await FirebaseReviewService.postReview(review)
            // property updates need to be run in main thread, as well as draft service since it uses main context
            DispatchQueue.main.async {
                if let draft = self.existingDraft {
                    DraftService.deleteDraft(draft)
                }
                self.didFinish = true
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
        return true
    }

    // returns flag indicating if draft saved succesfsfully
    // uses DraftService for this
    // note this is only ever called on button which runs on main thread so this is ok
    func saveDraft(uid: String) -> Bool{
        if reviewText.count >= 240 {
            error = "Review too long! Must be less <240 characters!"
            return false
        }

        if let existing = existingDraft {
            DraftService.updateDraft(existing, rating: rating, reviewText: reviewText)
        } else {
            DraftService.saveDraft(album: album, uid: uid, rating: rating, reviewText: reviewText)
        }
        didFinish = true
        return true
    }
}
