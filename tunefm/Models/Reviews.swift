//
//  Reviews.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation
import FirebaseFirestore

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    let uid: String
    let username: String
    let userPhotoBase64: String
    let albumName: String
    let artist: String
    let artworkURL: String
    let releaseDate: Date
    let rating: Double
    let reviewText: String
    let timestamp: Date
}
