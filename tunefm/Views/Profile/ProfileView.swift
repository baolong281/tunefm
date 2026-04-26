//
//  ProfileView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = ProfileViewModel()

    @State private var reviewToDelete: Review? = nil
    @State private var showDeleteConfirmation = false
    
    @State private var imageData: Data? = nil
    @State private var profileImage: Image? = nil


    var body: some View {
        NavigationStack {
            ScrollView {
                // profile image + username at top
                VStack(spacing: 16) {
                    Text("@\(authViewModel.user?.username ?? "")")
                        .font(.appDisplay)
                        .fontWeight(.bold)
                    
                    ProfilePhotoPicker(imageData: $imageData, profileImage: $profileImage)
                    
                    // reviews feed
                    Text("Published Reviews")
                        .font(.appTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.reviews.isEmpty {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("No reviews yet")
                                .font(.appTitle)
                            Text("Trying writing one!")
                                .font(.appBody)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // we use lazy vstack because its better for long lists apparently
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.reviews) { review in
                                // this takes a review + closure of what to do if we press the delete button
                                // we set reviewToDelete to this review object and set the flag to use the alert
                                ReviewCardView(review: review, showUser: false) {
                                    reviewToDelete = review
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            // show settings icon in top right
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            // alert for when delete review is pressed
            .alert("Delete Review", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let review = reviewToDelete {
                        viewModel.deleteReview(review)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this review? This action is permanent.")
            }
            // fetch reviews on view load + show user photo
            // fetchreviews attaches a listener so we get automatic updates when something is added or removed
            .onAppear {
                if let uid = authViewModel.user?.uid {
                    viewModel.fetchReviews(for: uid)
                }
                if let user = authViewModel.user {
                    guard let data = ImageHelper.fromBase64(user.photoBase64) else { return }
                    guard let uiImage = UIImage(data: data) else { return }
                    profileImage = Image(uiImage: uiImage)
                }
            }
            // when we change profile data on ui, we need to update this in the database too
            .onChange(of: imageData) { _, newData in
                guard let newData = newData else { return }
                authViewModel.updateProfilePhoto(imageData: newData)
            }
        }
    }
}
