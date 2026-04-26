//
//  AlbumSearchView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI

struct AlbumSearchView: View {
    @State private var query = ""
    @State private var albums: [Album] = []
    
    // keep track of the currently running search, we want to do some debounce so it doesnt search every time we put a character in
    @State private var searchTask: Task<Void, Never>? = nil

    var body: some View {
        NavigationStack {
            // search box at the top
            VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search albums...", text: $query)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    .padding(10)
                    .background(Color.appSurfaceMuted)
                    .cornerRadius(12)
                    
                if albums.isEmpty {
                    VStack(spacing: 8) {
                        Text("No albums yet")
                            .font(.appTitle)
                        Text("Try a different search query maybe?")
                            .font(.appBody)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // list of albums
                    List(albums, id: \.collectionId) { album in
                        // each album is a link to the createreview screen with this selected album provided
                        NavigationLink {
                            // we construct viewModel ourselves depending on if we are making a brand new review or one from a draft
                            CreateReviewView(viewModel: CreateReviewViewModel(album: album))
                        } label: {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: album.artworkUrl100)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.appSurfaceMuted
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(6)
                                
                                VStack(alignment: .leading) {
                                    Text(album.collectionName)
                                    Text(album.artistName)
                                        .font(.appCaption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(20)
            .navigationTitle("Album Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        // whenever query is changed we run a new one and cancel any old ones for debouncing
        .onChange(of: query) { oldValue, newValue in
               // cancel the last running search and make a new one
               searchTask?.cancel()

               searchTask = Task {
                   try? await Task.sleep(nanoseconds: 400_000_000) // debounce 400ms
                   guard !Task.isCancelled else { return }

                   // fetch new albums
                   let results = try? await AlbumSearchService.search(query: newValue)

                   // state updates need to be done in main thread
                   await MainActor.run {
                       self.albums = results ?? []
                   }
               }
           }
    }
}

