//
//  HomeModelTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/10/23.
//


import XCTest
import CoreData
@testable import _43_Chordable

final class HomeModelTests: XCTestCase {
    var homeModel: HomeModel!
    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
  
    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.newBackgroundContext()
        homeModel = HomeModel(context: mockContext)
    }
  
    override func tearDownWithError() throws {
        homeModel = nil
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }
  
    func testAppOpened() throws {
        XCTAssertEqual(homeModel.streak, 0, "Initial streak should be 0")
        XCTAssertNil(homeModel.lastOpened, "lastOpened should be nil initially")
        
        homeModel.appOpened()
        XCTAssertEqual(homeModel.streak, 1, "Streak should increment after app opened")
        XCTAssertNotNil(homeModel.lastOpened, "lastOpened should not be nil after app opened")
    }
  
    func testAppOpened_LastOpenedIsToday() throws {
        let today = Date()
        homeModel.lastOpened = today
        homeModel.streak = 1

        homeModel.appOpened()
        XCTAssertEqual(homeModel.streak, 1, "Streak should not change for opening app again today")
    }

    func testAppOpened_LastOpenedIsYesterday() throws {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        homeModel.lastOpened = yesterday
        homeModel.streak = 1

        homeModel.appOpened()
        XCTAssertEqual(homeModel.streak, 2, "Streak should increment if app opened the day after last opened")
    }

    func testAppOpened_LastOpenedNotTodayOrYesterday() throws {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        homeModel.lastOpened = twoDaysAgo
        homeModel.streak = 1

        homeModel.appOpened()
        XCTAssertEqual(homeModel.streak, 1, "Streak should reset if app opened more than a day after last opened")
    }

    func testFetchChords() throws {
        let chord1 = Chord(context: mockContext)
        chord1.completed = false

        let chord2 = Chord(context: mockContext)
        chord2.completed = true

        try mockContext.save()

        let fetchResults = homeModel.fetchChords(context: mockContext)
        XCTAssertEqual(fetchResults.total, 2, "Total chords count should match")
        XCTAssertEqual(fetchResults.completed, 1, "Completed chords count should match")
    }
  
    func testFetchSongs() throws {
        let song1 = Song(context: mockContext)
        song1.unlocked = true

        let song2 = Song(context: mockContext)
        song2.unlocked = false

        try mockContext.save()

        let fetchResults = homeModel.fetchSongs(context: mockContext)
        XCTAssertEqual(fetchResults.total, 2, "Total songs count should match")
        XCTAssertEqual(fetchResults.unlocked, 1, "Unlocked songs count should match")
    }

    func testFetchChordsWithError() throws {
        mockContext.performAndWait {
            mockContext.rollback()
        }

        let fetchResults = homeModel.fetchChords(context: mockContext)
        XCTAssertEqual(fetchResults.total, 0, "Total chords count should be 0 on error")
        XCTAssertEqual(fetchResults.completed, 0, "Completed chords count should be 0 on error")
    }

    func testFetchSongsWithError() throws {
        mockContext.performAndWait {
            mockContext.rollback()
        }

        let fetchResults = homeModel.fetchSongs(context: mockContext)
        XCTAssertEqual(fetchResults.total, 0, "Total songs count should be 0 on error")
        XCTAssertEqual(fetchResults.unlocked, 0, "Unlocked songs count should be 0 on error")
    }
}
