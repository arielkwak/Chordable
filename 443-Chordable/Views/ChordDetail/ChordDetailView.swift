//
//  ChordDetailView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import SwiftUI
import AVFoundation

struct ChordDetailView: View {
  @ObservedObject var audio = ChordDetailViewController()
  
  let chord: Chord

  var body: some View {
    VStack {
      // play chord audio
      if audio.status == .stopped {
        Button("Hear Chord", action: {
          audio.playChord(chordName: "\(chord.chord_name ?? "")")
        })
      }
      
      Text(chord.displayable_name ?? "")
        .font(.largeTitle)
        .padding()
      
      Text(chord.quality ?? "")
        .font(.largeTitle)
        .padding()
      
      Spacer()
      // Display corresponding chord image
      Image("\(chord.chord_name ?? "")_diagram")
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

