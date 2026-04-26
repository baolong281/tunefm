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
    @EnvironmentObject private var tabState: TabState
    
    @State private var draftToDelete: Draft? = nil
    @State private var draftToEdit: Draft? = nil
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.drafts.isEmpty {
                    VStack(spacing: 8) {
                        Text("No drafts yet")
                            .font(.appTitle)
                        Text("Save a review as a draft to see it here.")
                            .font(.appBody)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // list of drafts
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.drafts) { draft in
                                // draft card that we pass closures to
                                DraftCardView(draft: draft) {
                                    // on edit
                                    draftToEdit = draft
                                } onPublish: {
                                    // publish to firebase then delete from local storage
                                    // then switch to feed
                                    Task {
                                        await viewModel.publishDraft(draft, user: authViewModel.user!)
                                        viewModel.deleteDraft(draft)
                                        tabState.switchToFeed()
                                        dismiss()
                                    }
                                } onDelete: {
                                    // set draft to delete then show popup
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
            // navigate to CreateReviewView when we get a draft to edit
            // we pass the draft as well so it is populatedj
            .navigationDestination(item: $draftToEdit) { draft in
                CreateReviewView(viewModel: CreateReviewViewModel(
                    album: draft.toAlbum(),
                    existingDraft: draft
                ))
            }
            // delete alert for draft
            // delete the draft then refetch drafts from local storage
            .alert("Delete Draft", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let draft = draftToDelete {
                        viewModel.deleteDraft(draft)
                        
                        guard let uid = authViewModel.user?.uid else { return }
                        viewModel.fetchDrafts(uid: uid)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this draft? This action is permanent.")
            }
            // on load we need to fetch the drafts
            .onAppear {
                guard let uid = authViewModel.user?.uid else { return }
                viewModel.fetchDrafts(uid: uid)
            }
        }
    }
}
