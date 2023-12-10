//
//  AlertItemTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/8/23.
//

import XCTest
import SwiftUI
@testable import _43_Chordable

import XCTest
import SwiftUI
@testable import _43_Chordable

class AlertItemTests: XCTestCase {

    func testAlertItemInitializationWithString() {
        let title = "Test Title"
        let message = "Test Message"

        let alertItem = AlertItem(title: title, message: message)

        XCTAssertNotNil(alertItem.id, "AlertItem should have a non-nil UUID")
    }

    func testAlertItemInitializationWithText() {
        let titleText = Text("Title Text")
        let messageText = Text("Message Text")

        let alertItem = AlertItem(title: titleText, message: messageText)

        XCTAssertNotNil(alertItem.id, "AlertItem should have a non-nil UUID")
      
    }
}

extension Text {
    var string: String {
        "\(self)"
    }
}
