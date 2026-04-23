//
//  PlaylistListView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import SwiftUI

struct PlaylistListView: View {
    @State private var viewModel: PlaylistListViewModel

    init(viewModel: PlaylistListViewModel? = nil) {
        _viewModel = State(initialValue: viewModel ?? PlaylistListViewModel())
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if viewModel.rowViewModels.isEmpty {
                ContentUnavailableView {
                    Label("No Playlists Yet", systemImage: "waveform")
                        .symbolEffect(.variableColor.iterative.reversing)
                } description: {
                    Text("Tap + to create one.")
                }
                .tint(AppTheme.accent)
            } else {
                List {
                    ForEach(viewModel.rowViewModels) { rowVM in
                        NavigationLink {
                            SongListView(playlist: rowVM.playlist)
                        } label: {
                            PlaylistRowView(viewModel: rowVM)
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                    .onDelete { viewModel.delete(at: $0) }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("SoundVault")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Playlist", systemImage: "plus", action: { viewModel.showingAddSheet = true })
                    .fontWeight(.semibold)
                    .tint(AppTheme.accent)
            }
        }
        .sheet(isPresented: $viewModel.showingAddSheet) {
            AddPlaylistSheet()
        }
    }
}

#Preview {
    NavigationStack {
        PlaylistListView(
            viewModel: PlaylistListViewModel(
                context: PersistenceController.preview.container.viewContext
            )
        )
    }
}
