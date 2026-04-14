//
//  Persistence.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        result.seedIfNeeded(into: result.container.viewContext)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SoundVault")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true

        if !UserDefaults.standard.bool(forKey: "hasSeededInitialData") {
            seedIfNeeded(into: container.viewContext)
            UserDefaults.standard.set(true, forKey: "hasSeededInitialData")
        }
    }

    func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    // MARK: - Seeding

    private func seedIfNeeded(into context: NSManagedObjectContext) {
        do {
            let playlists = try SeedDataLoader.loadPlaylists()
            CoreDataSeeder.seed(playlists, into: context)
            save(context)
        } catch {
            // Seed data is best-effort; the app is fully functional without it.
            print("[SoundVault] Seed data skipped: \(error.localizedDescription)")
        }
    }
}
