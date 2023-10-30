//
//  ChordDetailView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI

struct ChordDetailView: View {
    let chord: Chord

    var body: some View {
        VStack {
            Text(chord.chord_name ?? "")
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .navigationTitle(chord.chord_name ?? "Chord Detail")
    }
}

//
//struct ChordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChordDetailView()
//    }
//}
