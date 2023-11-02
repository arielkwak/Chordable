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
  @State var hasMicAccess = false
  @State var displayNotification = false
  
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
    
    // record chord
    Button {
      // record audio for 5 seconds
      if audio.status == .stopped {
        if hasMicAccess {
          audio.record(forDuration: 5)
        } else {
          requestMicrophoneAccess()
        }
      } else {
        audio.stopRecording()
      }
    } label: {
      // change images from assets import
      Image(audio.status == .recording ?
            "button-record-active" :
            "button-record-inactive")
      .resizable()
      .scaledToFit()
    }
  }
  
  private func requestMicrophoneAccess() {
    if #available(iOS 17.0, *) {
      AVAudioApplication.requestRecordPermission { granted in
        hasMicAccess = granted
        if granted {
          audio.record(forDuration: 5)
        } else {
          displayNotification = true
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
}

//
//struct ChordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChordDetailView()
//    }
//}

