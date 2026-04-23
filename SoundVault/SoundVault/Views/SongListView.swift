//
//  SongListView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import SwiftUI

struct SongListView: View {
    @State private var viewModel: SongListViewModel

    init(playlist: Playlist) {
        _viewModel = State(initialValue: SongListViewModel(playlist: playlist))
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if viewModel.songViewModels.isEmpty {
                ContentUnavailableView {
                    Label("No Songs Yet", systemImage: "music.note.list")
                        .symbolEffect(.variableColor.iterative.reversing)
                } description: {
                    Text("Tap + to add one.")
                }
                .tint(AppTheme.accent)
            } else {
                List {
                    // MARK: - Header
                    Section {
                        PlaylistHeaderView(
                            playlist: viewModel.playlist,
                            songCount: viewModel.songViewModels.count
                        )
                        .listRowInsets(.init())
                        .listRowBackground(Color.clear)
                        .listSectionSeparator(.hidden)
                        .id(viewModel.playlistVersion)
                    }

                    // MARK: - Songs
                    Section {
                        ForEach(viewModel.songViewModels) { songVM in
                            Button {
                                viewModel.setNowPlaying(id: songVM.id)
                            } label: {
                                SongRowView(viewModel: songVM, isNowPlaying: songVM.id == viewModel.nowPlayingID)
                            }
                            .listRowBackground(AppTheme.surface)
                        }
                        .onDelete { viewModel.delete(at: $0) }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(viewModel.playlist.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Song", systemImage: "plus", action: { viewModel.showingAddSheet = true })
                    .fontWeight(.semibold)
                    .tint(AppTheme.accent)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("Edit") {
                    viewModel.showingEditSheet = true
                }
                .tint(AppTheme.accent)
            }
        }
        .sheet(isPresented: $viewModel.showingAddSheet) {
            AddSongSheet(playlist: viewModel.playlist)
        }
        .sheet(isPresented: $viewModel.showingEditSheet, onDismiss: {
            viewModel.bumpPlaylistVersion()
        }) {
            EditPlaylistSheet(playlist: viewModel.playlist)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    if let playlist = try? context.fetch(Playlist.fetchRequest()).first {
        NavigationStack {
            SongListView(playlist: playlist)
        }
    }
}
