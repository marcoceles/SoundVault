//
//  AddSongSheet.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

private enum AddSongTab {
    case new, existing
}

struct AddSongSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: AddSongTab = .new
    @State private var newSongVM: AddSongViewModel
    @State private var existingVM: AddExistingSongsViewModel

    init(playlist: Playlist) {
        _newSongVM = State(initialValue: AddSongViewModel(playlist: playlist))
        _existingVM = State(initialValue: AddExistingSongsViewModel(playlist: playlist))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Mode", selection: $selectedTab) {
                    Text("New Song").tag(AddSongTab.new)
                    Text("Existing Song").tag(AddSongTab.existing)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 12)

                Group {
                    if selectedTab == .new {
                        newSongForm
                    } else {
                        existingSongList
                    }
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(selectedTab == .new ? "New Song" : "Add Existing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    confirmButton
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - New Song Form

    private var newSongForm: some View {
        Form {
            Section("Track Info") {
                TextField("Song title", text: $newSongVM.title)
                TextField("Artist", text: $newSongVM.artist)
            }
            Section("Duration") {
                TextField("Seconds (e.g. 213)", text: $newSongVM.durationText)
                    .keyboardType(.numberPad)
            }
        }
        .scrollContentBackground(.hidden)
    }

    // MARK: - Existing Songs List

    @ViewBuilder
    private var existingSongList: some View {
        if existingVM.availableSongs.isEmpty {
            existingEmptyState
        } else {
            let grouped = Dictionary(grouping: existingVM.availableSongs, by: \.sourceLabel)
            let sortedKeys = grouped.keys.sorted()
            List {
                ForEach(sortedKeys, id: \.self) { key in
                    Section {
                        ForEach(grouped[key]!, id: \.id) { song in
                            existingSongRow(song)
                        }
                    } header: {
                        Text("From: \(key)")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    private func existingSongRow(_ song: Song) -> some View {
        Button {
            existingVM.toggle(song)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title ?? "")
                        .font(.body).fontWeight(.medium)
                        .foregroundStyle(AppTheme.primaryText)
                    Text(song.artist ?? "")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                Spacer()
                Text(song.formattedDuration)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(AppTheme.secondaryText)
                if existingVM.isSelected(song) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.accent)
                        .padding(.leading, 4)
                }
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(existingVM.isSelected(song) ? AppTheme.surface : Color.clear)
        .animation(.easeInOut(duration: 0.15), value: existingVM.isSelected(song))
    }

    private var existingEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.accent)
            Text("No other songs available.")
                .font(.title3).fontWeight(.semibold)
                .foregroundStyle(AppTheme.primaryText)
            Text("Add songs to other playlists first.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Confirm Button

    @ViewBuilder
    private var confirmButton: some View {
        if selectedTab == .new {
            Button("Add") {
                newSongVM.save()
                dismiss()
            }
            .fontWeight(.semibold)
            .tint(AppTheme.accent)
            .disabled(!newSongVM.isValid)
        } else {
            Button(existingVM.confirmTitle) {
                existingVM.save()
                dismiss()
            }
            .fontWeight(.semibold)
            .tint(AppTheme.accent)
            .disabled(!existingVM.canConfirm)
        }
    }
}
