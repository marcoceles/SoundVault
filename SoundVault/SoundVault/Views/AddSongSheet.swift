//
//  AddSongSheet.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct AddSongSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddSongViewModel

    init(playlist: Playlist) {
        _viewModel = State(initialValue: AddSongViewModel(playlist: playlist))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Track Info") {
                    TextField("Song title", text: $viewModel.title)
                    TextField("Artist", text: $viewModel.artist)
                }
                Section("Duration") {
                    TextField("Seconds (e.g. 213)", text: $viewModel.durationText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("New Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .tint(AppTheme.accent)
                    .disabled(!viewModel.isValid)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
