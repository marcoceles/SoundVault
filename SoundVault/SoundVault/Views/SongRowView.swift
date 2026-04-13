//
//  SongRowView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct SongRowView: View {
    let song: Song
    let isNowPlaying: Bool

    @State private var pulse = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isNowPlaying ? AppTheme.accent : AppTheme.surface)
                    .frame(width: 32, height: 32)
                if isNowPlaying {
                    Image(systemName: "waveform")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                } else {
                    Text("\(song.trackNumber)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
            .scaleEffect(pulse ? 1.1 : 1.0)

            VStack(alignment: .leading, spacing: 2) {
                Text(song.title ?? "")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(isNowPlaying ? AppTheme.accent : AppTheme.primaryText)
                Text(song.artist ?? "")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()

            Text(song.formattedDuration)
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(minHeight: 56)
        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .onAppear {
            guard isNowPlaying else { return }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
