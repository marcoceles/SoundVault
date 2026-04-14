//
//  PlaylistListViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

@Observable
final class PlaylistListViewModel: NSObject {
    private(set) var rowViewModels: [PlaylistRowViewModel] = []
    var showingAddSheet = false

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<Playlist>!
    private var contextObserver: NSObjectProtocol?

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
        rowViewModels = (frc.fetchedObjects ?? []).map(PlaylistRowViewModel.init)

        contextObserver = NotificationCenter.default.addObserver(
            forName: NSManagedObjectContext.didChangeObjectsNotification,
            object: context,
            queue: .main
        ) { [weak self] notification in
            self?.handleContextChange(notification)
        }
    }

    deinit {
        if let observer = contextObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.map { rowViewModels[$0].playlist }.forEach(context.delete)
        PersistenceController.shared.save(context)
    }

    // MARK: - Private

    private func handleContextChange(_ notification: Notification) {
        guard let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        let updatedPlaylists = updated.compactMap { $0 as? Playlist }
        guard !updatedPlaylists.isEmpty else { return }

        let updatedIDs = Set(updatedPlaylists.compactMap { $0.id })
        for rowVM in rowViewModels where updatedIDs.contains(rowVM.id) {
            rowVM.sync()
        }
    }
}

extension PlaylistListViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        MainActor.assumeIsolated {
            let fetched = frc.fetchedObjects ?? []
            let existingByID = Dictionary(uniqueKeysWithValues: rowViewModels.map { ($0.id, $0) })
            rowViewModels = fetched.map { playlist in
                let id = playlist.id ?? UUID()
                if let existing = existingByID[id] {
                    existing.sync()
                    return existing
                }
                return PlaylistRowViewModel(playlist: playlist)
            }
        }
    }
}
