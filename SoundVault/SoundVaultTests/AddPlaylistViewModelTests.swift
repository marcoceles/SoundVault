import Testing
import CoreData
@testable import SoundVault

@Suite("AddPlaylistViewModel")
@MainActor
struct AddPlaylistViewModelTests {

    let context: NSManagedObjectContext

    init() {
        context = makeInMemoryContext()
    }

    // MARK: - Validation

    @Test func isValidWithNonEmptyName() {
        let vm = AddPlaylistViewModel(context: context)
        vm.name = "My Playlist"
        #expect(vm.isValid)
    }

    @Test func isInvalidWithEmptyName() {
        let vm = AddPlaylistViewModel(context: context)
        #expect(!vm.isValid)
    }

    @Test func isInvalidWithWhitespaceOnlyName() {
        let vm = AddPlaylistViewModel(context: context)
        vm.name = "   "
        #expect(!vm.isValid)
    }

    // MARK: - Save

    @Test func saveCreatesPlaylistInContext() throws {
        let vm = AddPlaylistViewModel(context: context)
        vm.name = "Jazz Collection"
        vm.save()

        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlists = try context.fetch(request)
        #expect(playlists.count == 1)
        #expect(playlists.first?.name == "Jazz Collection")
    }

    @Test func saveTrimsWhitespaceFromName() throws {
        let vm = AddPlaylistViewModel(context: context)
        vm.name = "  Trimmed  "
        vm.save()

        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        let playlists = try context.fetch(request)
        #expect(playlists.first?.name == "Trimmed")
    }
}
