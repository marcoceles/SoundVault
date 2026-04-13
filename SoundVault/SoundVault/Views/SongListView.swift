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
        List {
            ForEach(viewModel.songs) { song in
                SongRowView(song: song, isNowPlaying: song.id == viewModel.nowPlayingID)
            }
            .onDelete { viewModel.delete(at: $0) }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(viewModel.playlist.name ?? "")
        .navigationBarTitleDisplayMode(.large)
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
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let playlist = try! context.fetch(Playlist.fetchRequest()).first!
    return NavigationStack {
        SongListView(playlist: playlist)
    }
}
