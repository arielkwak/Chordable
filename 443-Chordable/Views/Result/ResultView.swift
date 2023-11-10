//
//  ResultView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/9/23.
//

import SwiftUI

struct ResultView: View {
    let isSuccess: Bool
    let chord: Chord
    
    var body: some View {
        VStack {
            Text(resultMessage)
            // Add other UI elements as needed
        }
        .navigationBarTitle("Result", displayMode: .inline)
    }

    private var resultMessage: String {
        isSuccess ? "Correct! It's a \(chord.chord_name ?? "") chord." : "Try again! That was not a \(chord.chord_name ?? "") chord."
    }
}
