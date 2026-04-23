//
//  NewSongFormView.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

struct NewSongFormView: View {
    @Bindable var viewModel: AddSongViewModel

    var body: some View {
        Form {
            Section("Track Info") {
                TextField("Song title", text: $viewModel.title)
                TextField("Artist", text: $viewModel.artist)
            }
            Section("Duration") {
                TextField("Seconds (e.g. 213)", text: $viewModel.durationText)
                    .keyboardType(.numberPad)
            }
        }
        .scrollContentBackground(.hidden)
    }
}
