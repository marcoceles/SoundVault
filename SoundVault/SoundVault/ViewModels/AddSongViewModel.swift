//
//  AddSongViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable
final class AddSongViewModel {
    var title = ""
    var artist = ""
    var durationText = ""

    private let playlist: Playlist
    private let context: NSManagedObjectContext

    init(
        playlist: Playlist,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.playlist = playlist
        self.context = context
    }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !artist.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save() {
        let song = Song(context: context)
        song.id = UUID()
        song.title = title.trimmingCharacters(in: .whitespaces)
        song.artist = artist.trimmingCharacters(in: .whitespaces)
        song.duration = Double(durationText) ?? 0
        song.trackNumber = Int16((playlist.songs?.count ?? 0) + 1)
        song.playlist = playlist
        PersistenceController.shared.save(context)
    }
}
