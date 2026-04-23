//
//  PlaylistRowView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct PlaylistRowView: View {
    let viewModel: PlaylistRowViewModel

    var body: some View {
        HStack(spacing: 16) {
            PlaylistCoverView(
                artworkColor: viewModel.artworkColor,
                coverImageData: viewModel.coverImageData,
                size: 52
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.primaryText)
                Text("^[\(viewModel.songCount) song](inflect: true)")
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
