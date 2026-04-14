//
//  SeedSongDTO.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

struct SeedSongDTO: Decodable {
    let title: String
    let artist: String
    /// Duration in seconds.
    let duration: Double
}
