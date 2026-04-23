import Testing
import CoreData
@testable import SoundVault

@Suite("SongListViewModel")
@MainActor
struct SongListViewModelTests {

    let context: NSManagedObjectContext
    let playlist: Playlist

    init() {
        context = makeInMemoryContext()
        playlist = makePlaylist(in: context)
    }

    // MARK: - Fetch

    @Test func startsEmptyWithNoSongs() {
        let vm = SongListViewModel(playlist: playlist, context: context)
        #expect(vm.songViewModels.isEmpty)
    }

    @Test func fetchesSongsForPlaylist() {
        makeSong(title: "Track 1", trackNumber: 1, in: context, playlist: playlist)
        makeSong(title: "Track 2", trackNumber: 2, in: context, playlist: playlist)

        let vm = SongListViewModel(playlist: playlist, context: context)
        #expect(vm.songViewModels.count == 2)
    }

    @Test func fetchesOnlySongsForItsPlaylist() {
        let otherPlaylist = makePlaylist(name: "Other", in: context)
        makeSong(title: "Mine", in: context, playlist: playlist)
        makeSong(title: "Not Mine", in: context, playlist: otherPlaylist)

        let vm = SongListViewModel(playlist: playlist, context: context)
        #expect(vm.songViewModels.count == 1)
        #expect(vm.songViewModels.first?.title == "Mine")
    }

    @Test func songsAreSortedByTrackNumber() {
        makeSong(title: "Last",   trackNumber: 3, in: context, playlist: playlist)
        makeSong(title: "First",  trackNumber: 1, in: context, playlist: playlist)
        makeSong(title: "Middle", trackNumber: 2, in: context, playlist: playlist)

        let vm = SongListViewModel(playlist: playlist, context: context)
        #expect(vm.songViewModels.map(\.title) == ["First", "Middle", "Last"])
    }

    // MARK: - Now Playing

    @Test func setNowPlayingUpdatesID() {
        let vm = SongListViewModel(playlist: playlist, context: context)
        let id = UUID()
        vm.setNowPlaying(id: id)
        #expect(vm.nowPlayingID == id)
    }

    @Test func setNowPlayingToNilClearsSelection() {
        let vm = SongListViewModel(playlist: playlist, context: context)
        vm.setNowPlaying(id: UUID())
        vm.setNowPlaying(id: nil)
        #expect(vm.nowPlayingID == nil)
    }

    // MARK: - Playlist version

    @Test func bumpPlaylistVersionIncrementsCounter() {
        let vm = SongListViewModel(playlist: playlist, context: context)
        #expect(vm.playlistVersion == 0)
        vm.bumpPlaylistVersion()
        #expect(vm.playlistVersion == 1)
        vm.bumpPlaylistVersion()
        #expect(vm.playlistVersion == 2)
    }

    // MARK: - Delete

    @Test func deleteRemovesSong() async {
        makeSong(in: context, playlist: playlist)
        let vm = SongListViewModel(playlist: playlist, context: context)
        #expect(vm.songViewModels.count == 1)

        vm.delete(at: IndexSet(integer: 0))
        await Task.yield()
        #expect(vm.songViewModels.isEmpty)
    }
}
