import Testing
import CoreData
@testable import SoundVault

@Suite("PlaylistListViewModel")
@MainActor
struct PlaylistListViewModelTests {

    let context: NSManagedObjectContext

    init() {
        context = makeInMemoryContext()
    }

    // MARK: - Fetch

    @Test func startsEmptyWithNoPlaylists() {
        let vm = PlaylistListViewModel(context: context)
        #expect(vm.rowViewModels.isEmpty)
    }

    @Test func fetchesExistingPlaylists() {
        makePlaylist(name: "Rock", in: context)
        makePlaylist(name: "Jazz", in: context)

        let vm = PlaylistListViewModel(context: context)
        #expect(vm.rowViewModels.count == 2)
    }

    @Test func rowViewModelHasCorrectName() {
        makePlaylist(name: "My Playlist", in: context)
        let vm = PlaylistListViewModel(context: context)
        #expect(vm.rowViewModels.first?.name == "My Playlist")
    }

    // MARK: - Delete

    @Test func deleteRemovesPlaylist() async {
        makePlaylist(name: "To Delete", in: context)
        let vm = PlaylistListViewModel(context: context)
        #expect(vm.rowViewModels.count == 1)

        vm.delete(at: IndexSet(integer: 0))
        await Task.yield()
        #expect(vm.rowViewModels.isEmpty)
    }
}
