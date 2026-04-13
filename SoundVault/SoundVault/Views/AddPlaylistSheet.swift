//
//  AddPlaylistSheet.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import SwiftUI

struct AddPlaylistSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddPlaylistViewModel

    init(viewModel: AddPlaylistViewModel = AddPlaylistViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Playlist Name") {
                    TextField("e.g. Morning Chill", text: $viewModel.name)
                        .submitLabel(.done)
                }
            }
            .navigationTitle("New Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .tint(AppTheme.accent)
                    .disabled(!viewModel.isValid)
                }
            }
        }
        .presentationDetents([.height(240)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    AddPlaylistSheet(
        viewModel: AddPlaylistViewModel(
            context: PersistenceController.preview.container.viewContext
        )
    )
}
