//
//  PersistenceControllerTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/10/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

class PersistenceControllerTests: XCTestCase {
    var persistenceController: PersistenceController!

    override func setUpWithError() throws {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        super.tearDown()
    }

    func testInMemoryStoreLoading() {
        let description = persistenceController.container.persistentStoreDescriptions.first
        XCTAssertEqual(description?.url, URL(fileURLWithPath: "/dev/null"), "In-memory store URL should be '/dev/null'")
    }

    func testDataInitialization() {
        XCTAssertNotNil(persistenceController, "PersistenceController should be initialized")
        
        let context = persistenceController.container.viewContext
        XCTAssertNotNil(context, "ViewContext should be available")

        XCTAssertTrue(UserDefaults.standard.bool(forKey: "isDataInitialized"), "Data should be marked as initialized")
    }

    func testPersistentContainer() {
        XCTAssertNotNil(persistenceController.container, "Persistent container should be initialized")
        XCTAssertNotNil(persistenceController.container.viewContext, "ViewContext should be available")
    }

    func testAutomaticMergeChangesFromParent() {
        XCTAssertTrue(persistenceController.container.viewContext.automaticallyMergesChangesFromParent, "ViewContext should automatically merge changes from parent")
    }

    func testPreviewController() {
        let previewController = PersistenceController.preview
        XCTAssertNotNil(previewController, "Preview controller should be initialized")
        XCTAssertNotNil(previewController.container.viewContext, "Preview controller's ViewContext should be available")
    }
}
