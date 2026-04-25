//
//  CreateReviewView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

struct CreateReviewView: View {
    @ObservedObject var viewModel: CreateReviewViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: viewModel.album.artworkUrl100)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 50)
                .cornerRadius(6)
                
                VStack(alignment: .leading) {
                    Text(viewModel.album.collectionName)
                    Text(viewModel.album.artistName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Rating")
                    .font(.system(size: 18, weight: .bold))
                
                StarRatingView(rating: $viewModel.rating, editable: true)
            }
            
            TextEditor(text: $viewModel.reviewText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .frame(height: 200)
                .scrollContentBackground(.hidden)

            HStack(spacing: 16){
                Button("Save Draft") {
                    viewModel.saveDraft()
                }
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.black)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
                
                Button("Post Review") {
                    guard let user = authViewModel.user else { return }
                    viewModel.postReview(
                        uid: user.uid, username: user.username, userPhotoBase64: user.photoBase64
                    )
                }
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(24)
        .navigationTitle("New Review")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let dummyAlbum = Album(
        artistName: "Radiohead",
        artworkUrl100: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtWGSIvVyEH5txLOSUeWDmU69a4x7H4AYXjA&s",
        releaseDate: ISO8601DateFormatter().date(from: "2016-05-08T00:00:00Z")!,
        collectionName: "OK Computer",
        collectionId: 123456789
    )
    
    CreateReviewView(viewModel: CreateReviewViewModel(album: dummyAlbum))
}
