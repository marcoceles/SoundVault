//
//  EditPlaylistViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import UIKit
import _PhotosUI_SwiftUI

@Observable @MainActor
final class EditPlaylistViewModel {
    var name: String
    var selectedImageData: Data?
    var previewImage: UIImage?
    var isLoadingImage = false

    private let playlist: Playlist
    private let context: NSManagedObjectContext

    init(
        playlist: Playlist,
        context: NSManagedObjectContext? = nil
    ) {
        self.playlist = playlist
        self.context = context ?? PersistenceController.shared.container.viewContext
        self.name = playlist.name ?? ""
        self.selectedImageData = playlist.coverImageData
        self.previewImage = playlist.coverImage
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func loadImage(_ pickerItem: PhotosPickerItem) async {
        isLoadingImage = true
        defer { isLoadingImage = false }
        guard let data = try? await pickerItem.loadTransferable(type: Data.self),
              let image = UIImage(data: data),
              let compressed = image.compressed() else { return }
        previewImage = UIImage(data: compressed)
        selectedImageData = compressed
    }

    func removeImage() {
        previewImage = nil
        selectedImageData = nil
    }

    func save() {
        playlist.name = name.trimmingCharacters(in: .whitespaces)
        playlist.coverImageData = selectedImageData
        PersistenceController.shared.save(context)
    }
}
