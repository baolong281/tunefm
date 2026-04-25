//
//  Draft.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import Foundation

struct Draft: Identifiable, Hashable {
    let id: UUID
    let albumName: String
    let artist: String
    let artworkURL: String
    let albumReleaseDate: Date
    let rating: Double
    let reviewText: String
    let timestamp: Date

    init(from managed: DraftEntity) {
        self.id = managed.id ?? UUID()
        self.albumName = managed.albumName ?? ""
        self.artist = managed.artist ?? ""
        self.artworkURL = managed.artworkURL ?? ""
        self.albumReleaseDate = managed.albumReleaseDate ?? Date()
        self.rating = managed.rating
        self.reviewText = managed.reviewText ?? ""
        self.timestamp = managed.timestamp ?? Date()
    }
    
    func toAlbum() -> Album {
        return Album(artistName: self.artist, artworkUrl100: self.artworkURL, releaseDate: self.albumReleaseDate, collectionName: self.albumName, collectionId: 0)
    }
}
