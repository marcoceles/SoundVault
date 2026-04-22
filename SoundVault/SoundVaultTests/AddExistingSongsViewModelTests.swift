import Testing
import CoreData
@testable import SoundVault

@Suite("AddExistingSongsViewModel")
@MainActor
struct AddExistingSongsViewModelTests {

    let context: NSManagedObjectContext
    let playlist: Playlist

    init() {
        context = makeInMemoryContext()
        playlist = makePlaylist(in: context)
    }

    // MARK: - Available songs

    @Test func startsWithNoAvailableSongsWhenStoreIsEmpty() {
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        #expect(vm.availableSongs.isEmpty)
    }

    @Test func excludesSongsAlreadyInPlaylist() {
        makeSong(title: "Already Here", in: context, playlist: playlist)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        #expect(vm.availableSongs.isEmpty)
    }

    @Test func showsSongsNotYetInPlaylist() {
        makeSong(title: "Available", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        #expect(vm.availableSongs.count == 1)
        #expect(vm.availableSongs.first?.title == "Available")
    }

    @Test func availableSongsAreSortedByTitle() {
        makeSong(title: "Zebra", in: context)
        makeSong(title: "Apple", in: context)
        makeSong(title: "Mango", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        #expect(vm.availableSongs.map { $0.title ?? "" } == ["Apple", "Mango", "Zebra"])
    }

    // MARK: - Selection

    @Test func canConfirmIsFalseWithNoSelection() {
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        #expect(!vm.canConfirm)
    }

    @Test func toggleSelectsSong() throws {
        makeSong(title: "Selectable", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        let song = try #require(vm.availableSongs.first)
        #expect(!vm.isSelected(song))
        vm.toggle(song)
        #expect(vm.isSelected(song))
        #expect(vm.canConfirm)
    }

    @Test func toggleDeselectsAlreadySelectedSong() throws {
        makeSong(title: "Selectable", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        let song = try #require(vm.availableSongs.first)
        vm.toggle(song)
        vm.toggle(song)
        #expect(!vm.isSelected(song))
        #expect(!vm.canConfirm)
    }

    // MARK: - Confirm title

    @Test func confirmTitleWithNoSelection() {
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        #expect(vm.confirmTitle == "Done")
    }

    @Test func confirmTitleWithOneSongSelected() throws {
        makeSong(in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        let song = try #require(vm.availableSongs.first)
        vm.toggle(song)
        #expect(vm.confirmTitle == "Add Song")
    }

    @Test func confirmTitleWithMultipleSongsSelected() {
        makeSong(title: "Song A", in: context)
        makeSong(title: "Song B", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        vm.availableSongs.forEach { vm.toggle($0) }
        #expect(vm.confirmTitle == "Add 2 Songs")
    }

    // MARK: - Save

    @Test func saveAddsSelectedSongsToPlaylist() throws {
        makeSong(title: "To Add", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        let song = try #require(vm.availableSongs.first)
        vm.toggle(song)
        vm.save()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "ANY playlists == %@", playlist)
        let songs = try context.fetch(request)
        #expect(songs.count == 1)
        #expect(songs.first?.title == "To Add")
    }

    @Test func saveDoesNotAddUnselectedSongs() throws {
        makeSong(title: "Not Selected", in: context)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        vm.save()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "ANY playlists == %@", playlist)
        let songs = try context.fetch(request)
        #expect(songs.isEmpty)
    }

    @Test func saveDoesNotDuplicateSongsAlreadyInPlaylist() throws {
        makeSong(title: "Already Here", in: context, playlist: playlist)
        let vm = AddExistingSongsViewModel(playlist: playlist, context: context)
        // availableSongs is empty so save is a no-op
        vm.save()

        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "ANY playlists == %@", playlist)
        let songs = try context.fetch(request)
        #expect(songs.count == 1)
    }
}
