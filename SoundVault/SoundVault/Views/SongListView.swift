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

            if viewModel.songs.isEmpty {
                emptyState
            } else {
                List {
                    // MARK: - Header
                    Section {
                        PlaylistHeaderView(
                            playlist: viewModel.playlist,
                            songCount: viewModel.songs.count
                        )
                        .listRowInsets(.init())
                        .listRowBackground(Color.clear)
                        .listSectionSeparator(.hidden)
                    }

                    // MARK: - Songs
                    Section {
                        ForEach(viewModel.songs) { song in
                            Button {
                                viewModel.setNowPlaying(id: song.id)
                            } label: {
                                SongRowView(song: song, isNowPlaying: song.id == viewModel.nowPlayingID)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                }
                .tint(AppTheme.accent)
            }
        }
        .sheet(isPresented: $viewModel.showingAddSheet) {
            AddSongSheet(playlist: viewModel.playlist)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.accent)
                .symbolEffect(.variableColor.iterative.reversing)
            Text("No songs yet.")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.primaryText)
            Text("Tap + to add one.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let playlist = try! context.fetch(Playlist.fetchRequest()).first!
    return NavigationStack {
        SongListView(playlist: playlist)
    }
}
