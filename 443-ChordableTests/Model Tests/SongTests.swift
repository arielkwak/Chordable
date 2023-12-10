//
//  SongTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/10/23.
//

import XCTest
@testable import _43_Chordable
import CoreData

class SongExtensionTests: XCTestCase {
    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
    var chordDataInitializer: ChordDataInitializer!
    var songDataInitializer: SongDataInitializer!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext
        chordDataInitializer = ChordDataInitializer()
        songDataInitializer = SongDataInitializer()

        chordDataInitializer.initializeChordData(into: mockContext)
        songDataInitializer.initializeSongData(into: mockContext, bundle: Bundle(for: type(of: self)))
    }

    override func tearDownWithError() throws {
        mockContext = nil
        testCoreDataStack = nil
        chordDataInitializer = nil
        songDataInitializer = nil
        super.tearDown()
    }

    func testGetUniqueChordsForBeastOfBurden() {
        guard let song = fetchSongWithTitle("Beast Of Burden") else {
            XCTFail("Beast of Burden not found")
            return
        }
        let uniqueChords = song.getUniqueChords(context: mockContext)
        let expectedChords = ["E", "C#m", "B", "A"]
      XCTAssertEqual(uniqueChords.compactMap { $0.chord_name }.sorted(), expectedChords.sorted(), "Should return specific chords for Beast of Burden")
    }

    func testUpdateLockedSongs() {
        // Initially, Beast of Burden and Moonlight Shadow are locked
        XCTAssertTrue(fetchSongWithTitle("Beast Of Burden")?.unlocked == false, "Beast of Burden should initially be locked")
        XCTAssertTrue(fetchSongWithTitle("Moonlight Shadow")?.unlocked == false, "Moonlight Shadow should initially be locked")

        // Complete required chords
        completeChords(["E", "C#m", "B", "A"])

        // Call updateLockedSongs method
        Song.updateLockedSongs(context: mockContext)

        // Verify that Beast of Burden and Moonlight Shadow are unlocked
        XCTAssertTrue(fetchSongWithTitle("Beast Of Burden")?.unlocked == true, "Beast of Burden should be unlocked")
        XCTAssertTrue(fetchSongWithTitle("Moonlight Shadow")?.unlocked == true, "Moonlight Shadow should be unlocked")
    }

    func testFilterSongs() {
        // Filter locked songs with searchText "Drive"
        let lockedSongs = Song.filterSongs(songs: fetchAllSongs(), searchText: "Drive", tabSelection: 0)
        XCTAssertEqual(lockedSongs.count, 1, "Should return only one song with title 'Drive'")

        // Filter songs with genre "Alternative"
        let alternativeSongs = lockedSongs.filter { $0.genre == "Alternative" }
        XCTAssertTrue(alternativeSongs.count > 0, "Should return songs with genre 'Alternative'")
    }

    // Helper methods
    private func printSongStatus(_ title: String) {
        if let song = fetchSongWithTitle(title) {
            print("\(title) - Unlocked: \(song.unlocked)")
        } else {
            print("\(title) not found in context")
        }
    }

    private func fetchAllSongs() -> [Song] {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        do {
            return try mockContext.fetch(request)
        } catch {
            XCTFail("Error fetching songs: \(error)")
            return []
        }
    }

    private func fetchSongWithTitle(_ title: String) -> Song? {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let songs = try mockContext.fetch(request)
            return songs.first
        } catch {
            print("Error fetching song with title \(title): \(error)")
            return nil
        }
    }


    private func completeChords(_ chordNames: [String]) {
        let request: NSFetchRequest<Chord> = Chord.fetchRequest()
        request.predicate = NSPredicate(format: "chord_name IN %@", chordNames)
        if let chords = try? mockContext.fetch(request) {
            chords.forEach { $0.completed = true }
            try? mockContext.save()
        }
    }
}
