//
//  ImageHelper.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import UIKit

// we need to do profile pictures but firebase storage costs money
// instead we try to compress < 1mb and store as base64 in user field of firebase
struct ImageHelper {
    static let maxBytes = 900_000  // 900k since 1mb is firestore limit

    // compress until it fits into maxBytes
    // if it gets too compressed and still not less, it is too big and we return nil / reject
    static func compress(_ data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        
        // resize to 200x200 thumbnail first
        let thumbnail = image.preparingThumbnail(of: CGSize(width: 200, height: 200))
        
        // compress quality down until it fits
        var quality: CGFloat = 0.8
        while quality > 0.1 {
            if let compressed = thumbnail?.jpegData(compressionQuality: quality) {
                if compressed.count < maxBytes {
                    return compressed
                }
            }
            quality -= 0.1
        }
        return nil
    }
    
    static func toBase64(_ data: Data) -> String {
        data.base64EncodedString()
    }
    
    static func fromBase64(_ string: String) -> Data? {
        Data(base64Encoded: string)
    }
}
