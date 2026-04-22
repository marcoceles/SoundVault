//
//  AddExistingSongsViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable @MainActor
final class AddExistingSongsViewModel {
    private(set) var availableSongs: [Song] = []
    var selectedIDs: Set<UUID> = []

    private let playlist: Playlist
    private let context: NSManagedObjectContext

    init(playlist: Playlist, context: NSManagedObjectContext? = nil) {
        self.playlist = playlist
        self.context = context ?? PersistenceController.shared.container.viewContext
        fetchAvailableSongs()
    }

    // MARK: - Selection

    var canConfirm: Bool { !selectedIDs.isEmpty }

    var confirmTitle: String {
        switch selectedIDs.count {
        case 0:       return "Done"
        case 1:       return "Add Song"
        default:      return "Add \(selectedIDs.count) Songs"
        }
    }

    func toggle(_ song: Song) {
        guard let id = song.id else { return }
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }

    func isSelected(_ song: Song) -> Bool {
        guard let id = song.id else { return false }
        return selectedIDs.contains(id)
    }

    // MARK: - Save

    func save() {
        let alreadyIn = Set((playlist.songs as? Set<Song> ?? []).compactMap(\.id))
        let toAdd = availableSongs.filter {
            guard let id = $0.id else { return false }
            return selectedIDs.contains(id) && !alreadyIn.contains(id)
        }
        // trackNumber: existing songs define ordering; added songs append after current count.
        // Per-playlist ordering would require a join entity — out of scope for this demo.
        var nextTrack = Int16((playlist.songs?.count ?? 0) + 1)
        for song in toAdd {
            song.trackNumber = nextTrack
            playlist.addToSongs(song)
            nextTrack += 1
        }
        PersistenceController.shared.save(context)
    }

    // MARK: - Private

    private func fetchAvailableSongs() {
        let alreadyIn = Set((playlist.songs as? Set<Song> ?? []).compactMap(\.id))
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Song.title, ascending: true)]
        let all = (try? context.fetch(request)) ?? []
        availableSongs = all.filter {
            guard let id = $0.id else { return false }
            return !alreadyIn.contains(id)
        }
    }
}
