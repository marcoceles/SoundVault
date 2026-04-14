//
//  SongRowViewModel.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import Foundation

@Observable @MainActor
final class SongRowViewModel: Identifiable {
    let id: UUID
    let song: Song
    private(set) var title: String
    private(set) var artist: String
    private(set) var trackNumber: Int16
    private(set) var duration: Double

    var formattedDuration: String {
        TimeFormatter.format(seconds: duration)
    }

    init(song: Song) {
        self.id = song.id ?? UUID()
        self.song = song
        self.title = song.title ?? ""
        self.artist = song.artist ?? ""
        self.trackNumber = song.trackNumber
        self.duration = song.duration
    }

    func sync() {
        title = song.title ?? ""
        artist = song.artist ?? ""
        trackNumber = song.trackNumber
        duration = song.duration
    }
}
