//
//  DraftCardView.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//
// Views/Drafts/DraftCardView.swift
import SwiftUI

// drafts cards have few extra buttons from review cards so i just made a new one
// pass the draft object to display and some callbacks for when we pres the buttons
struct DraftCardView: View {
    let draft: Draft
    let onEdit: () -> Void
    let onPublish: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // album row
            // this probably should've been a component 
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: draft.artworkURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(draft.albumName)
                        .font(.system(size: 16, weight: .bold))
                    Text("\(draft.artist) · \(draft.albumReleaseDate.formatted(.dateTime.year()))")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.secondary)
                    StarRatingView(rating: .constant(draft.rating), editable: false)
                }
            }

            // review text
            if !draft.reviewText.isEmpty {
                Text("\"\(draft.reviewText)\"")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            // action buttons
            HStack(spacing: 8) {
                Button("Edit Draft") {
                    onEdit()
                }
                .font(.system(size: 12, weight: .medium))
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .clipShape(Capsule())

                Button("Publish") {
                    onPublish()
                }
                .font(.system(size: 12, weight: .medium))
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())

                Spacer()

                Button("Delete") {
                    onDelete()
                }
                .font(.system(size: 12, weight: .bold))
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color(.systemGray5))
                .foregroundColor(.red)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
