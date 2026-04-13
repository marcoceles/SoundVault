//
//  PlaylistListViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable
final class PlaylistListViewModel: NSObject {
    private(set) var playlists: [Playlist] = []
    var showingAddSheet = false

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<Playlist>!

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        super.init()

        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Playlist.createdAt, ascending: true)]
        request.fetchBatchSize = 20
        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc.delegate = self
        try? frc.performFetch()
        playlists = frc.fetchedObjects ?? []
    }

    func delete(at offsets: IndexSet) {
        offsets.map { playlists[$0] }.forEach(context.delete)
        PersistenceController.shared.save(context)
    }
}

extension PlaylistListViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        MainActor.assumeIsolated {
            playlists = frc.fetchedObjects ?? []
        }
    }
}
