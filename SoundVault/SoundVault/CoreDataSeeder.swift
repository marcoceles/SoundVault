//
//  CoreDataSeeder.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData

struct CoreDataSeeder {
    /// Inserts playlists and songs from DTOs into the given context.
    /// Each playlist's `createdAt` is offset by one day per index so the list
    /// appears in a stable, deterministic order.
    static func seed(_ playlists: [SeedPlaylistDTO], into context: NSManagedObjectContext) {
        for (index, dto) in playlists.enumerated() {
            let playlist = Playlist(context: context)
            playlist.id = UUID()
            playlist.name = dto.name
            playlist.artworkColor = dto.artworkColor
            playlist.createdAt = Date().addingTimeInterval(TimeInterval(-index * 86400))

            for (trackIndex, songDTO) in dto.songs.enumerated() {
                let song = Song(context: context)
                song.id = UUID()
                song.title = songDTO.title
                song.artist = songDTO.artist
                song.duration = songDTO.duration
                song.trackNumber = Int16(trackIndex + 1)
                song.playlist = playlist
            }
        }
    }
}
