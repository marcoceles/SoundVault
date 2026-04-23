//
//  PlaylistCoverView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct PlaylistCoverView: View {
    let artworkColor: String
    let coverImageData: Data?
    let size: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Group {
            if let data = coverImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(.rect(cornerRadius: size * 0.19))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.19)
                        .fill(Color(hex: artworkColor))
                    Image(systemName: "music.note")
                        .font(.system(size: size * 0.35))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .frame(width: size, height: size)
            }
        }
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.15), radius: 4, y: 2)
    }
}
