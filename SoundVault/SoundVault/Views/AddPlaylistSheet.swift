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
            Form {
                Section {
                    coverPicker
                }

                Section("Playlist Name") {
                    TextField("e.g. Morning Chill", text: $viewModel.name)
                        .submitLabel(.done)
                }
            }
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
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
			viewModel.loadImage(newItem)
        }
    }

	// MARK: - Image Picker
    private var coverPicker: some View {
        HStack {
            Spacer()
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
					if let previewImage = viewModel.previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(AppTheme.surface)
                            .frame(width: 80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(AppTheme.secondaryText.opacity(0.3), lineWidth: 1)
                            )
						if viewModel.isLoadingImage {
                            ProgressView()
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .font(.title2)
                                .foregroundStyle(AppTheme.accent)
                        }
                    }
                }
            }
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    AddPlaylistSheet(
        viewModel: AddPlaylistViewModel(
            context: PersistenceController.preview.container.viewContext
        )
    )
}
