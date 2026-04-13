//
//  SongListViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable
final class SongListViewModel: NSObject {
    private(set) var songs: [Song] = []
    let playlist: Playlist
    var nowPlayingID: UUID?
    var showingAddSheet = false

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<Song>?

    init(
        playlist: Playlist,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.playlist = playlist
        self.context = context
        super.init()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "playlist == %@", playlist)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Song.trackNumber, ascending: true)]
        request.fetchBatchSize = 20
        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc?.delegate = self
        try? frc?.performFetch()
        songs = frc?.fetchedObjects ?? []
		nowPlayingID = songs.first?.id
    }

    func delete(at offsets: IndexSet) {
        offsets.map { songs[$0] }.forEach(context.delete)
        PersistenceController.shared.save(context)
    }

	func setNowPlaying(id: UUID?) {
		nowPlayingID = id
	}
}

extension SongListViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        MainActor.assumeIsolated {
            songs = frc?.fetchedObjects ?? []
        }
    }
}
