//
//  PlaylistRowViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import Foundation

@Observable @MainActor
final class PlaylistRowViewModel: Identifiable {
    let id: UUID
    let playlist: Playlist
    private(set) var name: String
    private(set) var artworkColor: String
    private(set) var coverImageData: Data?
    private(set) var songCount: Int

    init(playlist: Playlist) {
        self.id = playlist.id ?? UUID()
        self.playlist = playlist
        self.name = playlist.name ?? ""
        self.artworkColor = playlist.artworkColor ?? "#888888"
        self.coverImageData = playlist.coverImageData
        self.songCount = playlist.songs?.count ?? 0
    }

    func sync() {
        name = playlist.name ?? ""
        artworkColor = playlist.artworkColor ?? "#888888"
        coverImageData = playlist.coverImageData
        songCount = playlist.songs?.count ?? 0
    }
}
