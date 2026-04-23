import CoreData
@testable import SoundVault

// Each NSPersistentContainer(name:) call creates a separate NSManagedObjectModel instance.
// Core Data validates relationship assignments by NSEntityDescription identity, so objects
// from different model instances are rejected even when the Swift type name matches.
// Sharing one model across all test containers prevents this crash.
private let sharedTestModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

func makeInMemoryContext() -> NSManagedObjectContext {
    let container = NSPersistentContainer(name: "SoundVault", managedObjectModel: sharedTestModel)
    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    container.loadPersistentStores { _, error in
        if let error { fatalError("Test store failed to load: \(error)") }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container.viewContext
}

@discardableResult
func makePlaylist(
    name: String = "Test Playlist",
    in context: NSManagedObjectContext
) -> Playlist {
    let playlist = Playlist(context: context)
    playlist.id = UUID()
    playlist.name = name
    playlist.createdAt = Date()
    playlist.artworkColor = "#A8D8EA"
    try? context.save()
    return playlist
}

@discardableResult
func makeSong(
    title: String = "Test Song",
    artist: String = "Test Artist",
    trackNumber: Int16 = 1,
    duration: Double = 180,
    in context: NSManagedObjectContext,
    playlist: Playlist? = nil
) -> Song {
    let song = Song(context: context)
    song.id = UUID()
    song.title = title
    song.artist = artist
    song.trackNumber = trackNumber
    song.duration = duration
    if let playlist { playlist.addToSongs(song) }
    try? context.save()
    return song
}
