//
//  SeedDataLoader.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import Foundation

enum SeedDataError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "playlists.json not found in the app bundle."
        case .decodingFailed(let underlying):
            return "Failed to decode seed data: \(underlying.localizedDescription)"
        }
    }
}

struct SeedDataLoader {
    /// Decodes and returns playlists from the bundled `playlists.json` file.
    static func loadPlaylists() throws -> [SeedPlaylistDTO] {
        guard let url = Bundle.main.url(forResource: "playlists", withExtension: "json") else {
            throw SeedDataError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let container = try JSONDecoder().decode(SeedDataContainer.self, from: data)
            return container.playlists
        } catch let error as SeedDataError {
            throw error
        } catch {
            throw SeedDataError.decodingFailed(error)
        }
    }
}
