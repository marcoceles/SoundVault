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
}
