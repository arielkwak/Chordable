//
//  Persistence.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

  // A static variable for the preview controller.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create dummy data for the preview here if necessary
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "_43_Chordable")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // Check if the data has been initialized
        if !UserDefaults.standard.bool(forKey: "isDataInitialized") {
            let chordDataInitializer = ChordDataInitializer()
            let songDataInitializer = SongDataInitializer()

            let context = container.viewContext
            chordDataInitializer.initializeChordData(into: context)
            songDataInitializer.initializeSongData(into: context)

            // Mark data as initialized
            UserDefaults.standard.setValue(true, forKey: "isDataInitialized")
        }
      
      
      
      
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
