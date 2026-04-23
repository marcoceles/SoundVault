import Testing
import CoreData
@testable import SoundVault

@Suite("AddSongViewModel")
@MainActor
struct AddSongViewModelTests {

    let context: NSManagedObjectContext
    let playlist: Playlist

    init() {
        context = makeInMemoryContext()
        playlist = makePlaylist(in: context)
    }

    // MARK: - Validation

    @Test func isValidWithTitleAndArtist() {
        let vm = AddSongViewModel(playlist: playlist, context: context)
        vm.title = "Bohemian Rhapsody"
        vm.artist = "Queen"
        #expect(vm.isValid)
    }

    @Test func isInvalidWithEmptyTitle() {
        let vm = AddSongViewModel(playlist: playlist, context: context)
        vm.artist = "Queen"
        #expect(!vm.isValid)
    }

    @Test func isInvalidWithEmptyArtist() {
        let vm = AddSongViewModel(playlist: playlist, context: context)
        vm.title = "Bohemian Rhapsody"
        #expect(!vm.isValid)
    }

    @Test func isInvalidWithWhitespaceOnly() {
        let vm = AddSongViewModel(playlist: playlist, context: context)
        vm.title = "  "
        vm.artist = "  "
        #expect(!vm.isValid)
    }

    // MARK: - Save

    @Test func saveCreatesSongInPlaylist() throws {
        let vm = AddSongViewModel(playlist: playlist, context: context)
        vm.title = "Imagine"
        vm.artist = "John Lennon"
        vm.durationText = "187"
        vm.save()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "ANY playlists == %@", playlist)
        let songs = try context.fetch(request)
        #expect(songs.count == 1)
        #expect(songs.first?.title == "Imagine")
        #expect(songs.first?.artist == "John Lennon")
        #expect(songs.first?.duration == 187)
    }

    @Test func saveFallsBackToZeroDurationForInvalidInput() throws {
        let vm = AddSongViewModel(playlist: playlist, context: context)
        vm.title = "Untitled"
        vm.artist = "Unknown"
        vm.durationText = "not-a-number"
        vm.save()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "ANY playlists == %@", playlist)
        let songs = try context.fetch(request)
        #expect(songs.first?.duration == 0)
    }
}
