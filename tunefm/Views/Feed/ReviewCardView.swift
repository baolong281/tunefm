//
//  SwiftUIView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

// Main horizontal card showing a review
// can show user info or not, used in feed + profile page
struct ReviewCardView: View {
    let review: Review
    let showUser: Bool
    var onDelete: (() -> Void)? = nil

    // Read values from user defaults, these are the defualt values
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
                            .foregroundColor(.appSurfaceMuted)
                            .frame(width: 32, height: 32)
                    }

                    Text("@\(review.username)")
                        .font(.appBodyBold)
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
                    Rectangle().foregroundColor(.appSurfaceMuted)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.albumName)
                        .font(.appBodyBold)
                        .padding(.trailing, 48)
                    
                    Text(showReleaseDate ? "\(review.artist) · \(review.releaseDate.formatted(.dateTime.year()))" : review.artist)
                        .font(.appCaption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 48)

                    if showStars {
                        StarRatingView(rating: .constant(review.rating), editable: false)
                    } else {
                        Text(String(format: "%.1f / 5.0", review.rating))
                            .font(.appCaption)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    }
                }
            }

            // review text
            if !review.reviewText.isEmpty {
                Text("\"\(review.reviewText)\"")
                    .font(.appBody)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.bottom, 24)
                    .padding(.top, 4)
            }

            // delete button, only shown if closure provided
            if let onDelete {
                HStack {
                    Spacer()
                    Button("Delete") {
                        onDelete()
                    }
                    .font(.appCaption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 18)
                    .background(Color.appSurfaceMuted)
                    .foregroundColor(.appDestructive)
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(12)
        // show date in top right
        .overlay(alignment: .topTrailing) {
            Text(DateHelper.timeAgoDisplay(date: review.timestamp))
                .font(.appCaption)
                .foregroundColor(.secondary)
                .padding(12)
        }
    }
}
