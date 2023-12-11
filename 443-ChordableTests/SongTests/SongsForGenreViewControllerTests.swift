//
//  SongsForGenreViewControllerTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/8/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

class SongsForGenreViewControllerTests: XCTestCase {

    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
    var controller: SongsForGenreViewController!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext

        createMockSongs()

        controller = SongsForGenreViewController(context: mockContext, genre: "Rock")
    }

    override func tearDownWithError() throws {
        mockContext = nil
        testCoreDataStack = nil
        controller = nil
        super.tearDown()
    }

    func createMockSongs() {
        let song1 = Song(context: mockContext)
        song1.title = "A Song"
        song1.genre = "Rock"
        song1.unlocked = true

        let song2 = Song(context: mockContext)
        song2.title = "B Song"
        song2.genre = "Pop"
        song2.unlocked = true
      
        let song3 = Song(context: mockContext)
        song3.title = "C SAng"
        song3.genre = "Rock"
        song3.unlocked = true

        do {
            try mockContext.save()
            print("Mock songs saved successfully")
        } catch {
            XCTFail("Failed to save mock songs: \(error)")
        }
    }


    func testInitializationFetchesSongs() {
        print("Testing initialization fetches songs")
        XCTAssertEqual(controller.songs.count, 2, "Should fetch one song for the 'Rock' genre")
        
    }

    func testApplyFilters() {
        print("Testing apply filters with searchText 'Song'")
        controller.searchText = "A"
        controller.applyFilters()

        print("Songs count: \(controller.songs.count)")
        print("Filtered songs count: \(controller.filteredSongs.count)")

        XCTAssertEqual(controller.filteredSongs.count, 2, "Filtering should result in one song")
    }
  
    func testSortedSongs() {
        let controller = SongsForGenreViewController(context: mockContext, genre: "Rock")
        
        controller.applyFilters()

        let sortedTitles = controller.sortedSongs.map { $0.title ?? "" }
        
        XCTAssertEqual(sortedTitles, ["A Song", "C SAng"], "Songs should be sorted by title in ascending order")
    }




}
