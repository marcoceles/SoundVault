//
//  AddPlaylistViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import UIKit
import _PhotosUI_SwiftUI

@Observable @MainActor
final class AddPlaylistViewModel {
    var name = ""
    var selectedImageData: Data?
	var previewImage: UIImage?
	var isLoadingImage: Bool = false

    private let context: NSManagedObjectContext
    private let palette = [
        "#A8D8EA", "#FF6B6B", "#74B9A0", "#2D3561",
        "#F9A825", "#C77DFF", "#FF9F43", "#00B894"
    ]

    init(context: NSManagedObjectContext? = nil) {
        self.context = context ?? PersistenceController.shared.container.viewContext
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save() {
        let playlist = Playlist(context: context)
        playlist.id = UUID()
        playlist.name = name.trimmingCharacters(in: .whitespaces)
        playlist.artworkColor = palette.randomElement()!
        playlist.createdAt = Date()
        playlist.coverImageData = selectedImageData
        PersistenceController.shared.save(context)
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
}
