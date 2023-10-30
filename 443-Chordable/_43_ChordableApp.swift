//
//  _43_ChordableApp.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI

@main
struct _43_ChordableApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
