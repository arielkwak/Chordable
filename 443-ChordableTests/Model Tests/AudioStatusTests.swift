//
//  AudioStatusTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/10/23.
//

import XCTest
@testable import _43_Chordable

final class AudioStatusTest: XCTestCase {

    override func setUpWithError() throws {
        print("AudioStatusTest: setUpWithError")
    }

    override func tearDownWithError() throws {
        print("AudioStatusTest: tearDownWithError")
    }

    func testEnumInitialization() {
        print("AudioStatusTest: Starting testEnumInitialization")
        XCTAssertEqual(AudioStatus.stopped, AudioStatus(rawValue: 0))
        XCTAssertEqual(AudioStatus.playing, AudioStatus(rawValue: 1))
        XCTAssertEqual(AudioStatus.recording, AudioStatus(rawValue: 2))
        print("AudioStatusTest: Finished testEnumInitialization")
    }
  
    func testEnumDescription() {
        print("AudioStatusTest: Starting testEnumDescription")
        XCTAssertEqual(AudioStatus.stopped.description, "Audio:Stopped")
        XCTAssertEqual(AudioStatus.playing.description, "Audio:Playing")
        XCTAssertEqual(AudioStatus.recording.description, "Audio:Recording")
        print("AudioStatusTest: Finished testEnumDescription")
    }
  
    func testAudioName() {
        print("AudioStatusTest: Starting testAudioName")
        XCTAssertEqual(AudioStatus.stopped.audioName, "Audio:Stopped")
        XCTAssertEqual(AudioStatus.playing.audioName, "Audio:Playing")
        XCTAssertEqual(AudioStatus.recording.audioName, "Audio:Recording")
        print("AudioStatusTest: Finished testAudioName")
    }
}
