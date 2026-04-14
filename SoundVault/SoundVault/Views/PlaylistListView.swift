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

    init(viewModel: PlaylistListViewModel = PlaylistListViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            if viewModel.rowViewModels.isEmpty {
                emptyState
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
            AddPlaylistSheet()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "waveform")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.accent)
                .symbolEffect(.variableColor.iterative.reversing)
            Text("No playlists yet.")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.primaryText)
            Text("Tap + to create one.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
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
