//
//  Playlist+Extensions.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import UIKit

extension Playlist {
    var songsArray: [Song] {
        let set = songs as? Set<Song> ?? []
        return set.sorted { $0.trackNumber < $1.trackNumber }
    }

    var coverImage: UIImage? {
        guard let data = coverImageData else { return nil }
        return UIImage(data: data)
    }
}
