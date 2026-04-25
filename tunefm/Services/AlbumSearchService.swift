//
//  AlbumSearchService.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Album]
}

struct Album: Decodable {
    let artistName: String
    let artworkUrl100: String
    let releaseDate: Date
    let collectionName: String
    let collectionId: Int

    enum CodingKeys: String, CodingKey {
        case artistName
        case artworkUrl100
        case releaseDate
        case collectionName
        case collectionId
    }
}

class AlbumSearchService {
    static func search(query: String) async throws -> [Album] {
        let cleaned = query
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let encodedQuery = cleaned.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        guard let url = URL(string: "https://itunes.apple.com/search?term=\(encodedQuery)&media=music&entity=album&limit=35&country=us") else {
            return []
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(SearchResponse.self, from: data)

        return response.results
    }
}
