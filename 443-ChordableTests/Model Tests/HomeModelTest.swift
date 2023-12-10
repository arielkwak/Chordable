//
//  HomeModel.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 12/5/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

final class HomeModelTest: XCTestCase {
    var homeModel: HomeModel!
    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
  
    override func setUpWithError() throws {
        super.setUp()
        print("Setting up TestCoreDataStack for testing...")
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.newBackgroundContext()
        homeModel = HomeModel(context: mockContext)
        print("HomeModel and mock context set up for testing")
    }
  
    override func tearDownWithError() throws {
        print("Tearing down HomeModelTest...")
        homeModel = nil
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }
  
    func testAppOpened() throws {
        print("Testing appOpened() function...")
        XCTAssertEqual(homeModel.streak, 0, "Initial streak should be 0")
        XCTAssertNil(homeModel.lastOpened, "lastOpened should be nil initially")
        
        homeModel.appOpened()
        XCTAssertEqual(homeModel.streak, 1, "Streak should increment after app opened")
        XCTAssertNotNil(homeModel.lastOpened, "lastOpened should not be nil after app opened")
        print("testAppOpened() completed")
    }
  
    func testAppOpened_LastOpenedIsToday() throws {
        let today = Date()
        homeModel.lastOpened = today
        homeModel.streak = 1

        homeModel.appOpened()
        
        XCTAssertEqual(homeModel.streak, 1, "Streak should not change for opening app again today")
    }

  
    func testFetchChords() throws {
        print("Starting testFetchChords()...")

        print("Creating and saving Chord entities...")
        let chord1 = Chord(context: mockContext)
        chord1.completed = false

        let chord2 = Chord(context: mockContext)
        chord2.completed = true

        XCTAssertNoThrow(try mockContext.save(), "Saving context should not throw an error")

        let fetchResults = homeModel.fetchChords(context: mockContext)
        XCTAssertEqual(fetchResults.total, 2, "Total chords count should match")
        XCTAssertEqual(fetchResults.completed, 1, "Completed chords count should match")

        print("Fetched results - Total: \(fetchResults.total), Completed: \(fetchResults.completed)")
        print("testFetchChords() completed")
    }
  
    func testFetchSongs() throws {
        print("Starting testFetchSongs()...")

        // Create and save Song entities for testing
        let song1 = Song(context: mockContext)
        song1.unlocked = true

        let song2 = Song(context: mockContext)
        song2.unlocked = false

        XCTAssertNoThrow(try mockContext.save(), "Saving context should not throw an error")

        let fetchResults = homeModel.fetchSongs(context: mockContext)
        XCTAssertEqual(fetchResults.total, 2, "Total songs count should match")
        XCTAssertEqual(fetchResults.unlocked, 1, "Unlocked songs count should match")

        print("Fetched results - Total: \(fetchResults.total), Unlocked: \(fetchResults.unlocked)")
        print("testFetchSongs() completed")
    }

}
