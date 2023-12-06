//
//  HomeModel.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 12/5/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

final class HomeModelTest: XCTestCase {
  var homeModel: HomeModel!
  var testCoreDataStack: TestCoreDataStack!
  var mockContext: NSManagedObjectContext!
  
  override func setUpWithError() throws {
    homeModel = HomeModel()
    testCoreDataStack = TestCoreDataStack()
    mockContext = testCoreDataStack.persistentContainer.newBackgroundContext()
  }
  
  override func tearDownWithError() throws {
    homeModel = nil
    testCoreDataStack = nil
    mockContext = nil
  }
  
  func testAppOpened() throws {
    XCTAssertEqual(homeModel.streak, 0)
    XCTAssertNil(homeModel.lastOpened)
    
    // Open app
    homeModel.appOpened()
    
    XCTAssertEqual(homeModel.streak, 1)
    XCTAssertNotNil(homeModel.lastOpened)
    
    // Opening again on same day should not change streak
    homeModel.appOpened()
    XCTAssertEqual(homeModel.streak, 1)
    
    // Open on the next day
    homeModel.lastOpened = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    homeModel.appOpened()
    XCTAssertEqual(homeModel.streak, 2)
  }
  
  func testFetchChords() throws {

    print("Context:", mockContext!)
    let chord1 = Chord(context: mockContext!)
    chord1.completed = false
    
    let chord2 = Chord(context: mockContext!)
    chord2.completed = true
    
    try! mockContext!.save()
    waitForExpectations(timeout: 2.0) { error in
        XCTAssertNil(error, "Save did not occur")
      }
  }
  
}
