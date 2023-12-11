//
//  ChordDetailViewControllerTest.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/8/23.
//

import XCTest
import CoreData
import AVFoundation
@testable import _43_Chordable

class ChordDetailViewControllerTests: XCTestCase {

    var chordDetailVC: ChordDetailViewController!
    var mockContext: NSManagedObjectContext!
    var testCoreDataStack: TestCoreDataStack!
    var mockChord: Chord!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext
        mockChord = Chord(context: mockContext)
        mockChord.chord_name = "TestChord"
        chordDetailVC = ChordDetailViewController(chord: mockChord)
    }

    override func tearDownWithError() throws {
        // Clean up and reset
        chordDetailVC = nil
        mockChord = nil
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }

    func testInitialStatus() {
        XCTAssertEqual(chordDetailVC.status, .stopped, "Initial status should be stopped")
        XCTAssertFalse(chordDetailVC.isRecordingActive, "Initial recording status should be false")
        XCTAssertFalse(chordDetailVC.displayNotification, "Initial displayNotification should be false")
    }

    func testMicrophoneAccessRequest() {
        chordDetailVC.hasMicAccess = true

        chordDetailVC.requestMicrophoneAccess()

        XCTAssertTrue(chordDetailVC.hasMicAccess, "Microphone access should remain true")
        XCTAssertFalse(chordDetailVC.displayNotification, "Display notification should be false if access is granted")
    }

//    func testCountdownTimer() {
//        chordDetailVC.startCountdown()
//        XCTAssertEqual(chordDetailVC.countdown, 3, "Countdown should start at 3")
//        XCTAssertTrue(chordDetailVC.isCountingDown, "Countdown flag should be true")
//        
//        let expectation = XCTestExpectation(description: "Countdown")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 8)
//        
//        XCTAssertFalse(chordDetailVC.isCountingDown, "Countdown should be finished")
//    }

//    func testDurationTimer() {
//        chordDetailVC.startDuration()
//        XCTAssertEqual(chordDetailVC.duration, 5, "Duration should start at 5 seconds")
//        XCTAssertTrue(chordDetailVC.isRecordingActive, "Recording should be active")
//
//        // Debugging: Print statement to track the flow
//        print("Test: Waiting for duration timer to finish...")
//
//        let expectation = XCTestExpectation(description: "Duration")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//            print("Test: Checking final state after duration...")
//            XCTAssertFalse(self.chordDetailVC.isRecordingActive, "Recording should be finished")
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 6)
//    }

  
//    func testStopRecording() {
//        chordDetailVC.startRecording(for: 1) { _ in }
//        let expectation = XCTestExpectation(description: "Recording")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 3)
//
//        chordDetailVC.stopRecording { predictedChord in
////            XCTAssertFalse(self.chordDetailVC.isRecordingActive, "Recording should be stopped")
////            XCTAssertNotNil(FileManager.default.contents(atPath: self.chordDetailVC.urlForMemo.path), "Recorded file should exist")
//        }
//    }
  
//    func testStartDuration() {
//        chordDetailVC.startDuration()
//        XCTAssertEqual(chordDetailVC.duration, 5, "Duration should start at 5 seconds")
//        XCTAssertTrue(chordDetailVC.isRecordingActive, "Recording should be active")
//
//        let expectation = XCTestExpectation(description: "Duration")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 7)
//        
////        XCTAssertFalse(chordDetailVC.isRecordingActive, "Recording should be finished")
//        XCTAssertEqual(chordDetailVC.duration, 0, "Duration should have counted down to 0")
//
////        XCTAssertEqual(chordDetailVC.status, .recording, "Status should be '.recording' when recording starts")
//    }


//    func testAudioPlayerDidFinishPlaying() {
//        chordDetailVC.status = .playing
//        let mockPlayer = AVAudioPlayer()
//        let expectation = XCTestExpectation(description: "Wait for audio to stop")
//
//        chordDetailVC.audioPlayerDidFinishPlaying(mockPlayer, successfully: true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.5)
//        XCTAssertEqual(chordDetailVC.status, .stopped, "Status should be '.stopped' after audio finishes playing")
//    }
  
//    func testPlayChord() {
//        let validChordName = "C"
//        chordDetailVC.playChord(chordName: validChordName)
//        let expectation = XCTestExpectation(description: "Wait for audio to play")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            expectation.fulfill()
//        }
//      wait(for: [expectation], timeout: 1.0)
//
//        XCTAssertEqual(chordDetailVC.status, .playing, "Status should be '.playing' when audio is playing")
//    }



}
