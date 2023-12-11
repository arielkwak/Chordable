//
//  ImageNamesTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/9/23.
//

import XCTest
import SwiftUI
@testable import _43_Chordable

class ImageNamesTests: XCTestCase {

    func testImageNames() {
        verifyImageExists(.spotifyLogoGreen)
        verifyImageExists(.spotifyLogoWhite)
        verifyImageExists(.spotifyLogoBlack)
        verifyImageExists(.spotifyAlbumPlaceholder)
    }

    private func verifyImageExists(_ imageName: ImageName) {
        let _ = Image(imageName)

        XCTAssertNotNil(UIImage(imageName), "UIImage should be initialized successfully for \(imageName.rawValue)")
    }
}
