//
//  TimeFormatter.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import Foundation

struct TimeFormatter {
    static func format(seconds: Double) -> String {
        let total = Int(seconds)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
