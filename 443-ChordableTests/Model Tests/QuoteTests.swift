//
//  QuoteTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/9/23.
//

import XCTest
@testable import _43_Chordable

class QuoteTests: XCTestCase {

    func testGetRandomQuote() {
        let quotes = Quote.Quotes()
        
        for _ in 1...10 {
            if let (artist, quote) = quotes.getRandomQuote() {
                XCTAssertNotNil(quotes.quotes[artist], "Artist should exist in the dictionary")
                XCTAssertTrue(quotes.quotes[artist]?.contains(quote) ?? false, "Quote should exist for the given artist")
            } else {
                XCTFail("getRandomQuote should return a non-nil tuple")
            }
        }
    }
}
