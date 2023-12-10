//
//  TestCoreDataStack.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 12/5/23.
//

import CoreData
import XCTest
@testable import _43_Chordable

final class TestCoreDataStack {

    var persistentContainer: NSPersistentContainer

    init() {
        print("Initializing TestCoreDataStack...")
        persistentContainer = NSPersistentContainer(name: "_43_Chordable")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Failed to load the persistent store: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("Persistent store loaded successfully: \(storeDescription)")
            }
        }

        print("TestCoreDataStack initialized with in-memory store")
    }
}
