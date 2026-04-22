//
//  Song+Extensions.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

extension Song {
    var formattedDuration: String {
        TimeFormatter.format(seconds: duration)
    }

    var sourceLabel: String {
        let names = (playlists as? Set<Playlist> ?? []).compactMap(\.name).sorted()
        return names.isEmpty ? "Not in any playlist" : names.joined(separator: ", ")
    }
}
