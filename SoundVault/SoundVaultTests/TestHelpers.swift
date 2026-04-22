import CoreData
@testable import SoundVault

func makeInMemoryContext() -> NSManagedObjectContext {
    PersistenceController(inMemory: true).container.viewContext
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
    playlist: Playlist
) -> Song {
    let song = Song(context: context)
    song.id = UUID()
    song.title = title
    song.artist = artist
    song.trackNumber = trackNumber
    song.duration = duration
    song.playlist = playlist
    try? context.save()
    return song
}
