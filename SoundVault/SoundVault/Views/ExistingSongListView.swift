//
//  ExistingSongListView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct ExistingSongListView: View {
    let viewModel: AddExistingSongsViewModel

    var body: some View {
        if viewModel.availableSongs.isEmpty {
            ExistingSongsEmptyView()
        } else {
            List {
                ForEach(viewModel.groupedBySource, id: \.key) { group in
                    Section {
                        ForEach(group.songs, id: \.id) { song in
                            ExistingSongRowView(
                                song: song,
                                isSelected: viewModel.isSelected(song),
                                onToggle: { viewModel.toggle(song) }
                            )
                        }
                    } header: {
                        Text("From: \(group.key)")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: - Empty State

private struct ExistingSongsEmptyView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Songs Available", systemImage: "music.note.list")
        } description: {
            Text("Add songs to other playlists first.")
        }
        .tint(AppTheme.accent)
    }
}
