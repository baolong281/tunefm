//
//  Reviews.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation
import FirebaseFirestore

// we use identifiable protocol so that in list views we dont have to pass keys or anything
// codable lets firestore automatically read and write data of this type
// reviews store user info in them as well so we dont have to do any joins but this is usually not how we should do it
struct Review: Identifiable, Codable {
    @DocumentID var id: String? // firestore property denoting id
    let uid: String //userid that posted this
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
