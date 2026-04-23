//
//  ExistingSongRowView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct ExistingSongRowView: View {
    let song: Song
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title ?? "")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(AppTheme.primaryText)
                    Text(song.artist ?? "")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                Spacer()
                Text(song.formattedDuration)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(AppTheme.secondaryText)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.accent)
                        .padding(.leading, 4)
                }
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(isSelected ? AppTheme.surface : Color.clear)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
