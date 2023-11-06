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
  @State var duration = 5
  @State var fingerButtonPressed = false
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  let chord: Chord

  var body: some View {
    ZStack{
      VStack{
        VStack {
          // MARK: - Hear Chord Example and Name -
          // play chord audio
          
          Button(action: {
            audio.playChord(chordName: "\(chord.chord_name ?? "")")
          }){
            HStack{
              let chordParts = (chord.displayable_name ?? "").components(separatedBy: "#")
              if let firstPart = chordParts.first {
                Text(firstPart)
                  .font(.custom("Barlow-BlackItalic", size: 50))
                  .foregroundColor(.white)
                  .fixedSize(horizontal: false, vertical: true)
                  .padding(.leading, 20)
              }
              if chordParts.count > 1 {
                Text("#" + chordParts[1])
                  .font(.custom("Barlow-BlackItalic", size: 25))
                  .foregroundColor(.white)
                  .fixedSize(horizontal: false, vertical: true)
                  .offset(x:-5, y: -10)
              }
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
          .padding(.top, 10)
          
          Text("Strum the highlighted strings!")
            .font(.custom("Barlow-Bold", size: 14))
            .padding(.bottom, 30)
            .foregroundStyle(Color.white)
          
          // Display corresponding chord image
          Image("\(chord.chord_name ?? "")_diagram")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.all, edges: .horizontal)
        }
        
        ZStack{
          Text("Check your finger position!")
            .font(.custom("Barlow-Bold", size: 14))
            .padding(.vertical, 30)
            .foregroundStyle(Color.white)
          
          HStack{
            Button(action: {
              fingerButtonPressed = true
            }){
              ZStack {
                RoundedRectangle(cornerRadius: 20)
                  .fill(Color.white)
                  .frame(width: 72, height: 84)
                
                VStack {
                  Image("finger_guide_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 34)
                    .scaleEffect(1.0)
                  
                  Text("Finger \n Guide")
                    .font(.custom("Barlow-Medium", size: 12))
                    .foregroundColor(Color.black)
                }
                .padding()
              }
            }
          }.padding(.leading, 300)
        }
        
        // MARK: - Recording Button -b
        
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
              VStack{
                ZStack{
                  Circle()
                    .fill(Color.white)
                    .frame(width: 77, height: 77)
                  Image(systemName: "mic.circle.fill")
                    .font(.system(size: 80))
                    .symbolEffect(.pulse, value: true)
                    .foregroundColor(Color(.systemRed))
                }
                Text("You have \(duration) second(s)!")
                  .font(.custom("Barlow-Bold", size: 14))
                  .foregroundStyle(Color.white)
              }
            } else {
              VStack{
                ZStack{
                  Circle()
                    .fill(Color.red)
                    .frame(width: 77, height: 77)
                  Image(systemName: "mic.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(.white))
                }
                Text("Try it!")
                  .font(.custom("Barlow-Bold", size: 14))
                  .foregroundStyle(Color.white)
              }
            }
          } else {
            // older vers
            // let imageName = (audio.status == .recording ? "mic.circle.fill" : "mic.circle")
            // Image(systemName: imageName)
            //   .font(.system(size: 70))
            //   .foregroundColor(Color(.systemRed))
            if audio.status == .recording{
              VStack{
                ZStack{
                  Circle()
                    .fill(Color.white)
                    .frame(width: 77, height: 77)
                  Image(systemName: "mic.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(.systemRed))
                }
                Text("You have \(countdown) second(s)")
                  .font(.custom("Barlow-Bold", size: 14))
                  .foregroundStyle(Color.white)
              }
            } else{
              VStack{
                ZStack{
                  Circle()
                    .fill(Color.white)
                    .frame(width: 77, height: 77)
                  Image(systemName: "mic.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(.systemRed))
                }
                Text("Try it!")
                  .font(.custom("Barlow-Bold", size: 14))
                  .foregroundStyle(Color.white)
              }
            }
          }
        }
      }
      .padding(.bottom, 60)
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
      
      if isCountingDown{
        Color.black
          .opacity(0.85)
          .edgesIgnoringSafeArea(.all)
        VStack {
          Text("Get Ready!")
            .foregroundStyle(Color.white)
            .font(.custom("Barlow-BlackItalic", size: 55))
            .padding(.bottom, -10)
          Text("\(countdown)")
            .font(.custom("Barlow-BlackItalic", size: 250))
            .foregroundStyle(Color.white)
            .padding(.bottom, 130)
        }
      }
    }
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
        startDuration()
      }
    }
    countdown = 3
  }
  
  func startDuration(){
    _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
      if duration > 1{
        duration -= 1
      } else{
        timer.invalidate()
      }
    }
    duration = 5
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
