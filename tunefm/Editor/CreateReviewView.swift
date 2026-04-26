//
//  CreateReviewView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

// Single view to create views or edit drafts
// only the viewModel cares about that logic however
struct CreateReviewView: View {
    @ObservedObject var viewModel: CreateReviewViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tabState: TabState
    
    // we need the dismiss so that if we go back to the add it shows the search again after making a post
    @Environment(\.dismiss) var dismiss
    
    // lets us tap out of keyboard
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // album information at top
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
                        .foregroundStyle(.secondary) }
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // star ratings
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
                .focused($isFocused)
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .lineLimit(3)
            }


            // save draft and post reviews button
            // on press we swap to the corresponding screens with tabState
            HStack(spacing: 16){
                Button("Save Draft") {
                    guard let uid = authViewModel.user?.uid else { return }
                    
                    let draftSuccessful = viewModel.saveDraft(uid: uid)
                    
                    if draftSuccessful {
                        tabState.switchToDrafts()
                        dismiss()
                    }
                }
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.black)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
                
                Button("Post Review") {
                    Task {
                        guard let user = authViewModel.user else { return }
                        let postedSuccessful = await viewModel.postReview(
                            uid: user.uid, username: user.username, userPhotoBase64: user.photoBase64
                        )
                        if postedSuccessful {
                            tabState.switchToFeed()
                            dismiss()
                        }
                    }
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
        // unfocus the keyboard if we tap anywhere
        .onTapGesture {
            isFocused = false
        }
    }
}
