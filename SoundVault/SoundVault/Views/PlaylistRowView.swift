//
//  PlaylistRowView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct PlaylistRowView: View {
    let playlist: Playlist

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: playlist.artworkColor ?? "#888888"))
                    .frame(width: 52, height: 52)
                    .shadow(
                        color: .black.opacity(colorScheme == .dark ? 0.4 : 0.15),
                        radius: 4, y: 2
                    )
                Image(systemName: "music.note")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(playlist.name ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.primaryText)
                Text("\(playlist.songsArray.count) songs")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
        .frame(minHeight: 72)
        .listRowBackground(AppTheme.surface)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .alignmentGuide(.listRowSeparatorLeading) { _ in 52 + 16 + 16 }
    }
}
