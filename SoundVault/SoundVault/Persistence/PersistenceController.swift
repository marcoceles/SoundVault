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
        result.seedData(into: result.container.viewContext)
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
            seedData(into: container.viewContext)
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

    // MARK: - Seed Data

    private func seedData(into context: NSManagedObjectContext) {
        let playlists: [(name: String, color: String, songs: [(title: String, artist: String, duration: Double)])] = [
            (
                name: "Chill Vibes",
                color: "#A8D8EA",
                songs: [
                    ("Ocean Eyes", "Billie Eilish", 198),
                    ("Lovely", "Billie Eilish & Khalid", 200),
                    ("Sunflower", "Post Malone & Swae Lee", 158),
                    ("cardigan", "Taylor Swift", 239),
                    ("Golden Hour", "JVKE", 209),
                    ("Breathe", "Télépopmusik", 268)
                ]
            ),
            (
                name: "Workout Fuel",
                color: "#FF6B6B",
                songs: [
                    ("Blinding Lights", "The Weeknd", 200),
                    ("HUMBLE.", "Kendrick Lamar", 177),
                    ("Power", "Kanye West", 292),
                    ("Till I Collapse", "Eminem", 297),
                    ("Eye of the Tiger", "Survivor", 244),
                    ("Can't Hold Us", "Macklemore & Ryan Lewis", 257)
                ]
            ),
            (
                name: "Deep Focus",
                color: "#74B9A0",
                songs: [
                    ("Experience", "Ludovico Einaudi", 345),
                    ("Clair de Lune", "Claude Debussy", 318),
                    ("Nuvole Bianche", "Ludovico Einaudi", 367),
                    ("River Flows in You", "Yiruma", 213),
                    ("Comptine d'un autre été", "Yann Tiersen", 148),
                    ("Gymnopédie No.1", "Erik Satie", 196)
                ]
            ),
            (
                name: "Late Night Jazz",
                color: "#2D3561",
                songs: [
                    ("So What", "Miles Davis", 562),
                    ("Take Five", "Dave Brubeck Quartet", 324),
                    ("Autumn Leaves", "Bill Evans Trio", 348),
                    ("My Favorite Things", "John Coltrane", 800),
                    ("Round Midnight", "Thelonious Monk", 338),
                    ("All Blues", "Miles Davis", 694)
                ]
            ),
            (
                name: "Road Trip Anthems",
                color: "#F9A825",
                songs: [
                    ("Don't Stop Believin'", "Journey", 251),
                    ("Bohemian Rhapsody", "Queen", 355),
                    ("Hotel California", "Eagles", 391),
                    ("Sweet Home Alabama", "Lynyrd Skynyrd", 284),
                    ("Mr. Brightside", "The Killers", 222),
                    ("Africa", "Toto", 295)
                ]
            ),
            (
                name: "Indie Discoveries",
                color: "#C77DFF",
                songs: [
                    ("Motion Sickness", "Phoebe Bridgers", 232),
                    ("Do I Wanna Know?", "Arctic Monkeys", 272),
                    ("Electric Feel", "MGMT", 230),
                    ("Such Great Heights", "The Postal Service", 264),
                    ("Ribs", "Lorde", 231),
                    ("Little Talks", "Of Monsters and Men", 266)
                ]
            )
        ]

        for (index, data) in playlists.enumerated() {
            let playlist = Playlist(context: context)
            playlist.id = UUID()
            playlist.name = data.name
            playlist.artworkColor = data.color
            playlist.createdAt = Date().addingTimeInterval(TimeInterval(-index * 86400))

            for (trackIndex, song) in data.songs.enumerated() {
                let s = Song(context: context)
                s.id = UUID()
                s.title = song.title
                s.artist = song.artist
                s.duration = song.duration
                s.trackNumber = Int16(trackIndex + 1)
                s.playlist = playlist
            }
        }

        save(context)
    }
}
