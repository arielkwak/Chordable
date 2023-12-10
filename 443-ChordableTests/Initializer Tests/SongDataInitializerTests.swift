//
//  SongDataInitializerTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/8/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

class SongDataInitializerTests: XCTestCase {

    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
    var chordInitializer: ChordDataInitializer!
    var songInitializer: SongDataInitializer!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext

        // Initialize both chord and song initializers
        chordInitializer = ChordDataInitializer()
        songInitializer = SongDataInitializer()

        // First, initialize chord data
        chordInitializer.initializeChordData(into: mockContext)

        // Then, initialize song data
        songInitializer.initializeSongData(into: mockContext, bundle: Bundle(for: type(of: self)))
    }

    override func tearDownWithError() throws {
        chordInitializer = nil
        songInitializer = nil
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }

    func testInitializeSongData() {
        let songFetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        do {
            let songs = try mockContext.fetch(songFetchRequest)
            XCTAssertGreaterThan(songs.count, 0, "Should have created songs")
        } catch {
            XCTFail("Error fetching songs: \(error)")
        }

        let chordInstanceFetchRequest: NSFetchRequest<SongChordInstance> = SongChordInstance.fetchRequest()
        do {
            let chordInstances = try mockContext.fetch(chordInstanceFetchRequest)
            XCTAssertGreaterThan(chordInstances.count, 0, "Should have created song chord instances")
        } catch {
            XCTFail("Error fetching song chord instances: \(error)")
        }
    }

}
