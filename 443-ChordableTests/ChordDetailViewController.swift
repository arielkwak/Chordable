//
//  ChordDetailViewController.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 11/12/23.
//

import XCTest
@testable import _43_Chordable
import AVFAudio

final class ChordDetailViewControllerTest: XCTestCase {
  
  var chordDetailViewController: ChordDetailViewController!
  var exampleChord: Chord!
  
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      super.setUp()
      let exampleChord = Chord()
      chordDetailViewController = ChordDetailViewController(chord: exampleChord)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      exampleChord = nil
      chordDetailViewController = nil
      super.tearDown()
    }

  func testPlayChord() throws {
    // Play chord with valid chord name
    let goodChordName = "Bm"
    try chordDetailViewController.playChord(chordName: goodChordName)
    // should be stopped after playing
    XCTAssertEqual(chordDetailViewController.status, .stopped)
    
  }
  
  func testPlayChordInvalid() throws {
    // Play chord with invalid chord name
    let badChordName = "Bminor"
    XCTAssertThrowsError(try chordDetailViewController.playChord(chordName: badChordName)) { error in
      guard let chordError = error as? ChordDetailError else {
        XCTFail("Expected ChordDetailError, but got \(type(of: error))")
        return
      }
      XCTAssertEqual(chordError, ChordDetailError.fileNotFound(chordName: badChordName))
    }
  }
  
  func testRecorderSetup() {
    let testRecorder = chordDetailViewController.setupRecorder
    XCTAssertNoThrow(testRecorder)
  }
  
  func testStartRecording() {
    XCTAssertNoThrow(chordDetailViewController.startRecording(for: 5) { _ in })
    XCTAssertEqual(chordDetailViewController.status, .recording)
  }
  
  func testStopRecording() {
    XCTAssertNoThrow(chordDetailViewController.stopRecording { _ in })
    XCTAssertEqual(chordDetailViewController.status, .stopped)
  }
  
  func testStartCountdown() {
    chordDetailViewController.startCountdown()
    XCTAssertEqual(chordDetailViewController.countdown, 3)
    XCTAssertTrue(chordDetailViewController.isCountingDown)
    
    let expectation = XCTestExpectation(description: "Countdown finished")
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
      XCTAssertFalse(chordDetailViewController.isCountingDown)
      XCTAssertEqual(chordDetailViewController.countdown, 1)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 5)
  }
  
  func testStartDuration() {
    // fails right now --> need to pass in a real Chord to the view controller to start duration
    chordDetailViewController.startDuration()
    XCTAssertTrue(chordDetailViewController.isRecordingActive)
    XCTAssertEqual(chordDetailViewController.duration, 5)
    
    let expectation = XCTestExpectation(description: "Recording duration finished")
    DispatchQueue.main.asyncAfter(deadline: .now() + 6 ) { [self] in
      XCTAssertFalse(chordDetailViewController.isRecordingActive)
      XCTAssertEqual(chordDetailViewController.duration, 0)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 7)
  }
  
  func testRequestMicrophoneAccess() {
    XCTAssertFalse(chordDetailViewController.hasMicAccess)
    chordDetailViewController.requestMicrophoneAccess()
//    XCTAssertTrue(chordDetailViewController.displayNotification)
  }
  
}
