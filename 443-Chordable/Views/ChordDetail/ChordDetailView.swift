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
    VStack{
      VStack {
        // MARK: - Hear Chord Example and Name -
        // play chord audio
        
        Button("Hear Chord", action: {
          audio.playChord(chordName: "\(chord.chord_name ?? "")")
        })
        
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
      
      // MARK: - Recording Button -
      
      // display countdown if counting down
      if isCountingDown {
        Text("Get Ready!")
        Text("\(countdown)")
          .bold()
      }
      
      Spacer()
      
      // record chord button, begin counting down/stop recording
      Button {
        // record audio
        if audio.status == .stopped {
          if hasMicAccess {
            startCountdown()
          } else {
            requestMicrophoneAccess()
          }
        } else if audio.status == .recording {
          audio.stopRecording()
        }
      } label: {
        // pulse if iOS17 +
        if #available(iOS 17.0, *) {
          if audio.status == .recording {
            Image(systemName: "mic.circle.fill")
              .font(.system(size: 70))
              .symbolEffect(.pulse, value: true)
              .foregroundColor(Color(.systemRed))
          } else {
            Image(systemName: "mic.circle")
              .font(.system(size: 70))
              .foregroundColor(Color(.systemRed))
          }
        } else {
          // older vers
          let imageName = (audio.status == .recording ? "mic.circle.fill" : "mic.circle")
          Image(systemName: imageName)
            .font(.system(size: 70))
            .foregroundColor(Color(.systemRed))
        }
      }
    }.background(Color.black) 
  }
  
  // start counting down
  func startCountdown() {
    isCountingDown = true
    _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      if countdown > 1 {
        countdown -= 1
      } else {
        isCountingDown = false
        timer.invalidate()
        audio.startRecording()
      }
    }
    countdown = 3
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
      // For iOS versions prior to 17, use AVAudioSession to request microphone access
       AVAudioSession.sharedInstance().requestRecordPermission { granted in
         hasMicAccess = granted
         if granted {
            startCountdown()
         } else {
            displayNotification = true
         }
      }
    }
  }
}