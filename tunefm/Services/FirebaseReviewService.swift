//
//  FirebaseReviewService.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//
import FirebaseFirestore

// Service for interacting with firebase to get/post reviews
struct FirebaseReviewService {
    private static let db = Firestore.firestore()
    private static let collection = db.collection("reviews")

    // get the entire feed and order by most recent
    // in the future this can be a listener instead
    static func fetchFeed() async throws -> [Review] {
        let snapshot = try await collection
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { doc in try? doc.data(as: Review.self) } 
    }

    // post a review given the review object
    // used in createalbumviewmodel
    static func postReview(_ review: Review) async throws {
        try collection.addDocument(from: review)
    }

    // delete a review given its id
    static func deleteReview(id: String) async throws {
        try await collection.document(id).delete()
    }
}
