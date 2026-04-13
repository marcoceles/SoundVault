//
//  SoundVaultApp.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import CoreData
import SwiftUI

@main
struct SoundVaultApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PlaylistListView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
