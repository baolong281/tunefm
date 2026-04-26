//
//  AlbumSearchService.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import Foundation


// API response types ----------------
// these should probably be in Models/
// responses from API look like this
struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Album]
}

// we use decodable protocol so jsondecoder can automatically serialize and deserialize our types
struct Album: Decodable {
    let artistName: String
    let artworkUrl100: String // probably should rename this just artowkrURL
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

// --------------------------------------

// use the itunes search api to get a list of albums for this query
class AlbumSearchService {
    static func search(query: String) async throws -> [Album] {
        // lowercase and get rid of whitespace for more normalized results
        let cleaned = query
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // need to encode for query strings
        let encodedQuery = cleaned.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        guard let url = URL(string: "https://itunes.apple.com/search?term=\(encodedQuery)&media=music&entity=album&limit=35&country=us") else {
            return []
        }

        // fetch the data
        let (data, _) = try await URLSession.shared.data(from: url)

        // decode into our types
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(SearchResponse.self, from: data)

        return response.results
    }
}
