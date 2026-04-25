//
//  SwiftUIView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

struct ReviewCardView: View {
    let review: Review
    let showUser: Bool
    var onDelete: (() -> Void)? = nil

    @AppStorage("showStars") var showStars: Bool = true
    @AppStorage("showReleaseDate") var showReleaseDate: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // user row
            if showUser {
                HStack (spacing: 8) {
                    if let imageData = ImageHelper.fromBase64(review.userPhotoBase64),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                    }

                    Text("@\(review.username)")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Spacer()

                }
            }
            
            // album row
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: review.artworkURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.albumName)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.trailing, 48)
                    
                    Text(showReleaseDate ? "\(review.artist) · \("CHANGE ACTUAL DATE LATER")" : review.artist)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.secondary)
                        .padding(.trailing, 48)

                    if showStars {
                        StarRatingView(rating: .constant(review.rating), editable: false)
                    } else {
                        Text(String(format: "%.1f / 5.0", review.rating))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // review text
            if !review.reviewText.isEmpty {
                Text("\"\(review.reviewText)\"")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.bottom, 24)
                    .padding(.top, 4)
            }

            // delete button — only shown if closure provided
            if let onDelete {
                HStack {
                    Spacer()
                    Button("Delete") {
                        onDelete()
                    }
                    .font(.system(size: 10, weight: .bold))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 18)
                    .background(Color(.systemGray5))
                    .foregroundColor(.red)
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(alignment: .topTrailing) {
            Text(DateHelper.timeAgoDisplay(date: review.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(12)
        }
    }
}
