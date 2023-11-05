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
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  let chord: Chord

  var body: some View {
    VStack{
      VStack {
        // MARK: - Hear Chord Example and Name -
        // play chord audio
        
        Button(action: {
          audio.playChord(chordName: "\(chord.chord_name ?? "")")
        }){
          HStack{
            Text(chord.displayable_name ?? "")
              .font(.custom("Barlow-BlackItalic", size: 50))
              .padding(.leading, 20)
              .foregroundStyle(Color.white)
            
            Text(chord.quality ?? "")
              .font(.custom("Barlow-Regular", size: 24))
              .padding(.trailing, 10)
              .foregroundStyle(Color.white)
            
            Image(systemName: "headphones")
              .font(.system(size: 23))
              .foregroundColor(Color(.white))
              .padding(.trailing, 20)
          }.frame(height: 84)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.bottom, 30)
        
        Text("Strum the highlighted strings!")
          .font(.custom("Barlow-Bold", size: 14))
          .padding(.bottom, 30)
          .foregroundStyle(Color.white)
        
        // Display corresponding chord image
        GeometryReader { geometry in
            Image("\(chord.chord_name ?? "")_diagram")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width)
        }
      }
      .navigationTitle(chord.chord_name ?? "Chord Detail")
      
      Text("Check your finger position!")
        .font(.custom("Barlow-Bold", size: 14))
        .padding(.vertical, 60)
        .foregroundStyle(Color.white)
      
      // MARK: - Recording Button -b
      
      // display countdown if counting down
      if isCountingDown {
        Text("Get Ready!")
        Text("\(countdown)")
          .bold()
          .foregroundStyle(Color.white)
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
      .padding(.bottom, 40)
    }
    .navigationBarBackButtonHidden(true) 
    .navigationBarItems(leading: Button(action: {
        self.presentationMode.wrappedValue.dismiss()
      }) {
        Image(systemName: "chevron.backward")
          .foregroundColor(.white)
        Text("Chords")
        .font(.custom("Barlow-Regular", size: 16))
        .foregroundColor(.white)
      })
    .background(Color.black)
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
