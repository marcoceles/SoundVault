//
//  Playlist+Extensions.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

extension Playlist {
    var songsArray: [Song] {
        let set = songs as? Set<Song> ?? []
        return set.sorted { $0.trackNumber < $1.trackNumber }
    }
}
