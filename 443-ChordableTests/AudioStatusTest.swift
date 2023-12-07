//
//  AudioStatusClass.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 11/9/23.
//

import XCTest
@testable import _43_Chordable

final class AudioStatusTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEnumInitialization() {
      // Test initialization
      XCTAssertEqual(AudioStatus.stopped, AudioStatus(rawValue: 0))
      XCTAssertEqual(AudioStatus.playing, AudioStatus(rawValue: 1))
      XCTAssertEqual(AudioStatus.recording, AudioStatus(rawValue: 2))
    }
  
    func testEnumDescription() {
      // Test description
      XCTAssertEqual(AudioStatus.stopped.description, "Audio:Stopped")
      XCTAssertEqual(AudioStatus.playing.description, "Audio:Playing")
      XCTAssertEqual(AudioStatus.recording.description, "Audio:Recording")
    }
  
    func testAudioName() {
      // Test the audioName
      XCTAssertEqual(AudioStatus.stopped.audioName, "Audio:Stopped")
      XCTAssertEqual(AudioStatus.playing.audioName, "Audio:Playing")
      XCTAssertEqual(AudioStatus.recording.audioName, "Audio:Recording")
    }

}
