//
//  ChordDetailViewController.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 11/12/23.
//

import XCTest
@testable import _43_Chordable

final class ChordDetailViewControllerTest: XCTestCase {
  
  var chordDetailViewController: ChordDetailViewController!
  
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      super.setUp()
      chordDetailViewController = ChordDetailViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      chordDetailViewController = nil
      super.tearDown()
    }

  func testPlayChord() throws {
    // Play chord with valid chord name
    let goodChordName = "Bm"
    try chordDetailViewController.playChord(chordName: goodChordName)
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

}
