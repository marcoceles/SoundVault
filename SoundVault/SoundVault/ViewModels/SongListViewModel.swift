//
//  SongListViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable @MainActor
final class SongListViewModel: NSObject {
    private(set) var songViewModels: [SongRowViewModel] = []
    let playlist: Playlist
    var nowPlayingID: UUID?
    var showingAddSheet = false
    var showingEditSheet = false
    private(set) var playlistVersion = 0

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<Song>?

    init(
        playlist: Playlist,
        context: NSManagedObjectContext? = nil
    ) {
        self.playlist = playlist
        self.context = context ?? PersistenceController.shared.container.viewContext
        super.init()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "ANY playlists == %@", playlist)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Song.trackNumber, ascending: true)]
        request.fetchBatchSize = 20
        frc = NSFetchedResultsController(
            fetchRequest: request,
			managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc?.delegate = self
        try? frc?.performFetch()
        songViewModels = (frc?.fetchedObjects ?? []).map(SongRowViewModel.init)
        nowPlayingID = songViewModels.first?.id
    }

    func delete(at offsets: IndexSet) {
        offsets.map { songViewModels[$0].song }.forEach { playlist.removeFromSongs($0) }
        PersistenceController.shared.save(context)
    }

    func setNowPlaying(id: UUID?) {
        nowPlayingID = id
    }

    func bumpPlaylistVersion() {
        playlistVersion += 1
    }
}

extension SongListViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        MainActor.assumeIsolated {
            let fetched = frc?.fetchedObjects ?? []
            let existingByID = Dictionary(uniqueKeysWithValues: songViewModels.map { ($0.id, $0) })
            songViewModels = fetched.map { song in
                let id = song.id ?? UUID()
                if let existing = existingByID[id] {
                    existing.sync()
                    return existing
                }
                return SongRowViewModel(song: song)
            }
        }
    }
}
