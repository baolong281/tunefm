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

    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var reviewToDelete: Review? = nil
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // profile header
                    VStack(spacing: 8) {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            if let user = authViewModel.user,
                               let imageData = ImageHelper.fromBase64(user.photoBase64),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .foregroundColor(.gray)
                                    .frame(width: 80, height: 80)
                            }
                        }
                        .onChange(of: selectedPhoto) {
                            Task {
                                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                                    authViewModel.updateProfilePhoto(imageData: data)
                                }
                            }
                        }

                        Text("@\(authViewModel.user?.username ?? "")")
                            .font(.headline)
                    }
                    .padding(.top)

                    // reviews feed
                    Text("Published Reviews")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.reviews.isEmpty {
                        Text("No reviews yet.")
                            .foregroundColor(.secondary)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.reviews) { review in
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
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
            .onAppear {
                if let uid = authViewModel.user?.uid {
                    viewModel.fetchReviews(for: uid)
                }
            }
        }
    }
}
