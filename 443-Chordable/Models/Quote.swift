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
            "Bob Marley": ["One good thing about music, when it hits you, you feel no pain."],
            "Beyoncé": ["It's not about perfection. It's about putpose."],
            "Mick Jagger":["Lose your dreams and you might lose your mind."],
            "Louis Armstrong":["Musicians don’t retire; they stop when there’s no more music in them."],
            "Billy Joel":["Musicians want to be the loud voice for so many quiet hearts."],
            "Nicki Minaj":["Your victory is right around the corner. Never give up."],
            "Elton John":["Music has healing power. It has the ability to take people out of themselves for a few hours"],
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
