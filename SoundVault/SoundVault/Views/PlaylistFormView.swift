//
//  PlaylistFormView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import PhotosUI
import SwiftUI

struct PlaylistFormView: View {
    @Binding var name: String
    @Binding var selectedItem: PhotosPickerItem?
    let previewImage: UIImage?
    let isLoadingImage: Bool
    var onRemoveImage: (() -> Void)? = nil

    var body: some View {
        Form {
            // MARK: - Cover Picker
            Section {
                HStack {
                    Spacer()
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ZStack {
                            if let previewImage {
                                Image(uiImage: previewImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(.rect(cornerRadius: 15))
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(AppTheme.surface)
                                    .stroke(AppTheme.secondaryText.opacity(0.3), lineWidth: 1)
                                    .frame(width: 80, height: 80)
                                if isLoadingImage {
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

                if previewImage != nil, let onRemoveImage {
                    Button("Remove Photo", action: onRemoveImage)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                }
            }

            Section("Playlist Name") {
                TextField("e.g. Morning Chill", text: $name)
                    .submitLabel(.done)
            }
        }
    }
}
