//
//  ChordDataInitializerTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/9/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

class ChordDataInitializerTests: XCTestCase {

    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
    var initializer: ChordDataInitializer!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext
        initializer = ChordDataInitializer()
    }

    override func tearDownWithError() throws {
        mockContext = nil
        testCoreDataStack = nil
        initializer = nil
        super.tearDown()
    }

    func testInitializeChordData() {
        initializer.initializeChordData(into: mockContext)

        let fetchRequest: NSFetchRequest<Chord> = Chord.fetchRequest()
        do {
            let chords = try mockContext.fetch(fetchRequest)
            XCTAssertGreaterThan(chords.count, 0, "Chords should be initialized")

            for difficulty in ChordDataInitializer.Difficulty.allCases {
                let expectedChords = difficulty.chords
                let fetchedChords = chords.filter { $0.difficulty == difficulty.description }
                XCTAssertEqual(fetchedChords.count, expectedChords.count, "Incorrect number of chords for \(difficulty.description) difficulty")

                for chord in expectedChords {
                    let matchingChord = fetchedChords.first { $0.chord_name == chord }
                    XCTAssertNotNil(matchingChord, "Chord \(chord) should exist")
                    XCTAssertEqual(matchingChord?.quality, chord.hasSuffix("m") ? "Minor" : "Major", "Incorrect quality for chord \(chord)")
                    XCTAssertEqual(matchingChord?.completed, false, "Chord \(chord) should be marked as not completed")
                }
            }

        } catch {
            XCTFail("Error fetching chords: \(error)")
        }
    }
}
