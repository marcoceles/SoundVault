//
//  PlaylistHeaderBackground.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

/// Atmospheric layered background for PlaylistHeaderView.
///
/// Layer order (bottom → top):
/// 1. `artworkColor` solid fill — the playlist's colour identity, always visible
/// 2. Blurred cover image — atmospheric depth when a custom image exists
/// 3. `artworkColor` tint — keeps colour identity readable through the blur
/// 4. `.ultraThinMaterial` — adds depth and ensures text legibility in both modes
struct PlaylistHeaderBackground: View {
    let artworkColor: String
    let coverImage: UIImage?

    var body: some View {
        ZStack {
            Color(hex: artworkColor)

            if let image = coverImage {
                Image(uiImage: image)
                    .resizable()
					.frame(height: 290)
					.aspectRatio(1, contentMode: .fit)
					.blur(radius: 10, opaque: false)
                    .clipped()
            }

            Color(hex: artworkColor)
                .opacity(0.1)

            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }
}
