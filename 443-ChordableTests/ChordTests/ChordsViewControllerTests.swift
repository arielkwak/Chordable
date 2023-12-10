//
//  ChordsViewControllerTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/9/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

class ChordsViewControllerTests: XCTestCase {

    var controller: ChordsViewController!
    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext
        controller = ChordsViewController()
        createMockChords()
    }

    override func tearDownWithError() throws {
        controller = nil
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }

    func testFetchChords() {
        controller.fetchChords()
        XCTAssertGreaterThan(controller.displayedChords.count, 0, "Should fetch chords")
    }

    func testFilterOnCompleted() {
        controller.filterOnCompleted = true
        let filteredChords = controller.displayedChords.filter { $0.completed }
        XCTAssertEqual(controller.displayedChords, filteredChords, "Only completed chords should be displayed")
    }

    func testSearchQuery() {
        controller.searchQuery = "specific chord name"
        let filteredChords = controller.displayedChords.filter { $0.displayable_name?.contains(controller.searchQuery) ?? false }
        XCTAssertEqual(controller.displayedChords, filteredChords, "Filtered chords should match search query")
    }

    func testCompleteChord() {
        guard let chord = controller.displayedChords.first else {
            XCTFail("No chords to complete")
            return
        }
        controller.completeChord(chord)
        XCTAssertTrue(chord.completed, "Chord should be marked as completed")
    }

    private func createMockChords() {
        let chord1 = Chord(context: mockContext)
        chord1.chord_id = UUID()
        chord1.chord_name = "C"
        chord1.displayable_name = "C"
        chord1.quality = "Major"
        chord1.difficulty = "easy"
        chord1.completed = false

        let chord2 = Chord(context: mockContext)
        chord2.chord_id = UUID()
        chord2.chord_name = "G"
        chord2.displayable_name = "G"
        chord2.quality = "Major"
        chord2.difficulty = "easy"
        chord2.completed = true

        let chord3 = Chord(context: mockContext)
        chord3.chord_id = UUID()
        chord3.chord_name = "Am"
        chord3.displayable_name = "A"
        chord3.quality = "Minor"
        chord3.difficulty = "medium"
        chord3.completed = false

        // Save the context to persist these mock chords
        do {
            try mockContext.save()
        } catch {
            XCTFail("Failed to save mock chords: \(error)")
        }
    }
}
