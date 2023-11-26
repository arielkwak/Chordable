//
//  Quote.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import Foundation

extension Quote {
    struct Quotes {
        let quotes: [String: [String]] = [
            "Adele": ["I don't make music for eyes. I make music for ears."],
            "Bob Marley": ["One good thing about music, when it hits you, you feel no pain"],
        ]

        func getRandomQuote() -> (String, String)? {
            guard let artist = quotes.keys.randomElement(),
                let quote = quotes[artist]?.randomElement() else {
                return nil
            }
            return (artist, quote)
        }
    }
}
