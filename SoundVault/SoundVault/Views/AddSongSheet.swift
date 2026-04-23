//
//  AddSongSheet.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI

private enum AddSongTab {
    case new, existing
}

struct AddSongSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: AddSongTab = .new
    @State private var newSongVM: AddSongViewModel
    @State private var existingVM: AddExistingSongsViewModel

    init(playlist: Playlist) {
        _newSongVM = State(initialValue: AddSongViewModel(playlist: playlist))
        _existingVM = State(initialValue: AddExistingSongsViewModel(playlist: playlist))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Mode", selection: $selectedTab) {
                    Text("New Song").tag(AddSongTab.new)
                    Text("Existing Song").tag(AddSongTab.existing)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 12)

                if selectedTab == .new {
                    NewSongFormView(viewModel: newSongVM)
                } else {
                    ExistingSongListView(viewModel: existingVM)
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(selectedTab == .new ? "New Song" : "Add Existing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    confirmButton
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Confirm Button

    @ViewBuilder
    private var confirmButton: some View {
        if selectedTab == .new {
            Button("Add") {
                newSongVM.save()
                dismiss()
            }
            .fontWeight(.semibold)
            .tint(AppTheme.accent)
            .disabled(!newSongVM.isValid)
        } else {
            Button(existingVM.confirmTitle) {
                existingVM.save()
                dismiss()
            }
            .fontWeight(.semibold)
            .tint(AppTheme.accent)
            .disabled(!existingVM.canConfirm)
        }
    }
}
