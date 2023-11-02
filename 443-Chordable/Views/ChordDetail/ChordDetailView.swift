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
  @State var countdown = 3
  @State var isCountingDown = false
  
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
    
    if isCountingDown {
      Text("\(countdown)")
    }
    
    // record chord
    Button {
      // record audio
      if audio.status == .stopped {
        if hasMicAccess {
          startCountdown()
        } else {
          requestMicrophoneAccess()
        }
      } else {
        audio.stopRecording()
      }
    } label: {
      // change images from assets import
      let imageName = (audio.status == .recording ? "mic.circle.fill" : "mic.circle")
      Image(systemName: imageName)
      .resizable()
      .scaledToFit()
    }
  }
  private func startCountdown() {
    isCountingDown = true
    _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
      if countdown > 0 {
        countdown -= 1
      } else {
        isCountingDown = false
        timer.invalidate()
        countdown = 3
        audio.record()
      }
    }
  }
  
  private func requestMicrophoneAccess() {
    if #available(iOS 17.0, *) {
      AVAudioApplication.requestRecordPermission { granted in
        hasMicAccess = granted
        if granted {
          startCountdown()
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

