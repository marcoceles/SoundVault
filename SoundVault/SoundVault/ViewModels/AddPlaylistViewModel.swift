//
//  AddPlaylistViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable
final class AddPlaylistViewModel {
    var name = ""

    private let context: NSManagedObjectContext
    private let palette = [
        "#A8D8EA", "#FF6B6B", "#74B9A0", "#2D3561",
        "#F9A825", "#C77DFF", "#FF9F43", "#00B894"
    ]

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
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
        PersistenceController.shared.save(context)
    }
}
