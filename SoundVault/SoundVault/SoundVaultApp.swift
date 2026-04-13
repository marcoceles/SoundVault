//
//  SoundVaultApp.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import SwiftUI
import CoreData

@main
struct SoundVaultApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
