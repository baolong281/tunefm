//
//  DraftsViewModel.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//
import Foundation
import Combine

class DraftsViewModel: ObservableObject {
    // list of drafts to display
    @Published var drafts: [Draft] = []

    // drafts shared locally so we need specific user id
    func fetchDrafts(uid: String) {
        drafts = DraftService.fetchDrafts(uid: uid)
    }

    // delete the draft from local storage
    func deleteDraft(_ draft: Draft) {
        DraftService.deleteDraft(draft)
    }

    // publish the draft to firebase
    func publishDraft(_ draft: Draft, user: AppUser) async {
        let review = Review(
            uid: user.uid,
            username: user.username,
            userPhotoBase64: user.photoBase64,
            albumName: draft.albumName,
            artist: draft.artist,
            artworkURL: draft.artworkURL,
            releaseDate: draft.albumReleaseDate,
            rating: draft.rating,
            reviewText: draft.reviewText,
            timestamp: Date()
        )
        
        do {
            try await FirebaseReviewService.postReview(review)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
