//
//  FirebaseReviewService.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//
import FirebaseFirestore

struct FirebaseReviewService {
    private static let db = Firestore.firestore()
    private static let collection = db.collection("reviews")

    static func fetchFeed() async throws -> [Review] {
        let snapshot = try await collection
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Review.self) }
    }

    static func fetchReviews(for uid: String) async throws -> [Review] {
        let snapshot = try await collection
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Review.self) }
    }

    static func postReview(_ review: Review) async throws {
        try collection.addDocument(from: review)
    }

    static func deleteReview(id: String) async throws {
        try await collection.document(id).delete()
    }
}
