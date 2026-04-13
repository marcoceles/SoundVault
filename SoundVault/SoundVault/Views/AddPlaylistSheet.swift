//
//  AddPlaylistSheet.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import PhotosUI
import SwiftUI

struct AddPlaylistSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddPlaylistViewModel
    @State private var selectedItem: PhotosPickerItem?

    init(viewModel: AddPlaylistViewModel = AddPlaylistViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            PlaylistFormView(
                name: $viewModel.name,
                selectedItem: $selectedItem,
                previewImage: viewModel.previewImage,
                isLoadingImage: viewModel.isLoadingImage
            )
            .navigationTitle("New Playlist")
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
        .task(id: selectedItem) {
            guard let item = selectedItem else { return }
            await viewModel.loadImage(item)
        }
    }
}

#Preview {
    AddPlaylistSheet(
        viewModel: AddPlaylistViewModel(
            context: PersistenceController.preview.container.viewContext
        )
    )
}
