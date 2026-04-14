//
//  PlaylistHeaderView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct PlaylistHeaderView: View {
    let playlist: Playlist
    let songCount: Int

    /// Decoded once per render; acceptable here because the header is a single
    /// view (not a list row) and is rebuilt from scratch via `.id(playlistVersion)`
    /// whenever the playlist is edited.
    private var coverImage: UIImage? {
        playlist.coverImageData.flatMap(UIImage.init(data:))
    }

    var body: some View {
        ZStack {
            PlaylistHeaderBackground(
                artworkColor: playlist.artworkColor ?? "#888888",
                coverImage: coverImage
            )

            // MARK: - Content
            VStack(spacing: 16) {
                PlaylistCoverView(
                    artworkColor: playlist.artworkColor ?? "#888888",
                    coverImageData: playlist.coverImageData,
                    size: 160
                )
                .shadow(color: .black.opacity(0.2), radius: 10, y: 6)

                VStack(spacing: 4) {
                    Text(playlist.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.primaryText)
                        .multilineTextAlignment(.center)

                    Text(songCount == 1 ? "1 song" : "\(songCount) songs")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
            .padding(.top, 28)
            .padding(.bottom, 52)
            .frame(maxWidth: .infinity)
        }
    }
}
