//
//  TestCoreDataStack.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 12/5/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

final class TestCoreDataStack {

      var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "_43_Chordable")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        return container
      }()


}
