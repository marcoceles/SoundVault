//
//  SeedPlaylistDTO.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

struct SeedPlaylistDTO: Decodable {
    let name: String
    let artworkColor: String
    let songs: [SeedSongDTO]
}

/// Top-level wrapper matching the JSON root object.
struct SeedDataContainer: Decodable {
    let playlists: [SeedPlaylistDTO]
}
