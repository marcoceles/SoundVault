//
//  EditPlaylistSheet.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import PhotosUI
import SwiftUI

struct EditPlaylistSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EditPlaylistViewModel
    @State private var selectedItem: PhotosPickerItem?

    init(playlist: Playlist) {
        _viewModel = State(initialValue: EditPlaylistViewModel(playlist: playlist))
    }

    var body: some View {
        NavigationStack {
            PlaylistFormView(
                name: $viewModel.name,
                selectedItem: $selectedItem,
                previewImage: viewModel.previewImage,
                isLoadingImage: viewModel.isLoadingImage,
                onRemoveImage: { viewModel.removeImage() }
            )
            .navigationTitle("Edit Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
        .task(id: selectedItem) {
            guard let item = selectedItem else { return }
            await viewModel.loadImage(item)
        }
    }
}
