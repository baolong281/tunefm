//
//  DraftsView.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import SwiftUI

struct DraftsView: View {
    @StateObject var viewModel = DraftsViewModel()
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var draftToDelete: Draft? = nil
    @State private var draftToEdit: Draft? = nil
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.drafts.isEmpty {
                    VStack(spacing: 8) {
                        Text("No drafts yet.")
                            .font(.headline)
                        Text("Save a review as a draft to see it here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.drafts) { draft in
                                DraftCardView(draft: draft) {
                                    // on edit
                                    draftToEdit = draft
                                } onPublish: {
                                    Task {
                                        await viewModel.publishDraft(draft, user: authViewModel.user!)
                                    }
                                } onDelete: {
                                    draftToDelete = draft
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Drafts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $draftToEdit) { draft in
                CreateReviewView(viewModel: CreateReviewViewModel(
                    album: draft.toAlbum(),
                    existingDraft: draft
                ))
            }
            .alert("Delete Draft", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let draft = draftToDelete {
                        viewModel.deleteDraft(draft)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this draft? This action is permanent.")
            }
            .onAppear {
                viewModel.fetchDrafts()
            }
        }
    }
}
