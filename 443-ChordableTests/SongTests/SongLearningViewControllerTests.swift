//
//  SongLearningViewControllerTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/9/23.
//

import XCTest
@testable import _43_Chordable
import CoreData

class SongLearningViewControllerTests: XCTestCase {

    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!
    var songLearningVC: SongLearningViewController!
    var mockSong: Song!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext
        createMockSongAndChordInstances()
        songLearningVC = SongLearningViewController(context: mockContext, song: mockSong)
    }

    override func tearDownWithError() throws {
        songLearningVC = nil
        mockSong = nil
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }

    func testPlayPauseToggled() {
        XCTAssertFalse(songLearningVC.isPlaying, "Initial state should be paused")

        songLearningVC.playPauseToggled()
        XCTAssertTrue(songLearningVC.isPlaying, "Should be playing after toggling")

        sleep(1)

        songLearningVC.playPauseToggled()
        XCTAssertFalse(songLearningVC.isPlaying, "Should be paused after toggling again")
    }

//    func testProgressUpdate() {
//        songLearningVC.startTimer()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            // Directly modify elapsedTime and call updateProgress
//            self.songLearningVC.elapsedTime = 1.0
//            self.songLearningVC.updateProgress()
//
//            XCTAssertGreaterThan(self.songLearningVC.progress, 0.0, "Progress should be updated during playback")
//
//            self.songLearningVC.stopTimer()
//        }
//    }


    func testChordUpdates() {
//        XCTAssertNil(songLearningVC.currentChords[0], "Initial chord should be nil")

        songLearningVC.playPauseToggled()
        sleep(2)
        songLearningVC.playPauseToggled()

        XCTAssertNotNil(songLearningVC.currentChords[0], "Chords should be updated based on elapsed time")
    }

    private func createMockSongAndChordInstances() {
        mockSong = Song(context: mockContext)
        mockSong.title = "Test Song"

        let chordInstance1 = SongChordInstance(context: mockContext)
        chordInstance1.start_time = 0.0
        chordInstance1.end_time = 5.0
        chordInstance1.song = mockSong

        let chordInstance2 = SongChordInstance(context: mockContext)
        chordInstance2.start_time = 5.0
        chordInstance2.end_time = 10.0
        chordInstance2.song = mockSong

        do {
            try mockContext.save()
            XCTAssertNotNil(mockSong, "Mock song should not be nil")
            XCTAssertNotNil(chordInstance1, "First chord instance should not be nil")
            XCTAssertNotNil(chordInstance2, "Second chord instance should not be nil")
            XCTAssertEqual(mockSong.songChordInstances?.count, 2, "There should be two chord instances associated with the song")
        } catch {
            XCTFail("Failed to save mock context: \(error)")
        }
    }


    private func createChordInstance(startTime: Float, endTime: Float) {
        let chordInstance = SongChordInstance(context: mockContext)
        chordInstance.start_time = startTime
        chordInstance.end_time = endTime
        chordInstance.song = mockSong
    }
}
