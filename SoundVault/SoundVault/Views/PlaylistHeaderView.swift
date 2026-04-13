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

    var body: some View {
        ZStack {
            Color(hex: playlist.artworkColor ?? "#888888")
            Rectangle().fill(.ultraThinMaterial)

            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, AppTheme.background.opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 48)
            }

            // MARK: - Content
            VStack(spacing: 16) {
                PlaylistCoverView(playlist: playlist, size: 160)
                    .shadow(color: .black.opacity(0.14), radius: 10, y: 4)

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
