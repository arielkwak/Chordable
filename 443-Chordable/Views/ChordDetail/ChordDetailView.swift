//
//  ChordDetailView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import SwiftUI
import AVFoundation

struct ChordDetailView: View {
  @ObservedObject var audio: ChordDetailViewController
  @State var fingerButtonPressed = false
  @State var holdingButtonPressed = false
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  let chord: Chord
  
  init(chord: Chord) {
    self.chord = chord
    self.audio = ChordDetailViewController(chord: chord)
  }

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
          .padding(.bottom, 20)
          .padding(.top, 50)
          .disabled(audio.isCountingDown || audio.isRecordingActive)
          
          Text("Strum the purple strings!")
            .font(.custom("Barlow-Bold", size: 14))
            .padding(.bottom, 20)
            .foregroundStyle(Color.white)
          
          // Display corresponding chord image
          Image("\(chord.chord_name ?? "")_diagram")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.all, edges: .horizontal)
        }
        
        ZStack{
          HStack{
            Button(action: {
              holdingButtonPressed = true
            }){
              ZStack {
                RoundedRectangle(cornerRadius: 20)
                  .fill(Color.white)
                  .frame(width: 72, height: 107)
                
                VStack {
                  Image("guitar_holding_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 43, height: 59)
                    .scaleEffect(1.0)
                  
                  Text("Holding \n Guide")
                    .font(.custom("Barlow-Medium", size: 12))
                    .foregroundColor(Color.black)
                }
                .padding()
              }
            }
            .disabled(audio.isCountingDown || audio.isRecordingActive)
          }
          .padding(.trailing, 300)
          .padding(.top, 20)
          
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
            .disabled(audio.isCountingDown || audio.isRecordingActive)
          }.padding(.leading, 300)
        }.padding(.top, -10)
        
        // MARK: - Recording Button -
        
        // record chord button, begin counting down/stop recording
        Button {
            // record audio
          if audio.status == .stopped {
            if audio.hasMicAccess {
              startCountdown()
            } else {
              requestMicrophoneAccess()
            }
          }
        }
 label: {
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
                Text("You have \(audio.duration) second(s)!")
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
                Text("You have \(audio.duration) second(s)!")
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
        NavigationLink(destination: ResultView(isSuccess: audio.isSuccess, chord: chord), isActive: $audio.showResultView) {
            EmptyView()
        }
        .hidden()
      }
      .padding(.bottom, 70)
      .padding(.top, -20)
      .navigationBarBackButtonHidden(true) // Always hide the default back button
      .navigationBarItems(leading: (!audio.isCountingDown && !audio.isRecordingActive) ? AnyView(Button(action: {
          self.presentationMode.wrappedValue.dismiss()
      }) {
          HStack {
              Image(systemName: "chevron.backward")
                  .foregroundColor(.white)
              Text("Chords")
                  .font(.custom("Barlow-Regular", size: 16))
                  .foregroundColor(.white)
          }
      }) : AnyView(EmptyView()))
      .background(Color.black)
      
      if audio.isCountingDown{
        Color.black
          .opacity(0.85)
          .edgesIgnoringSafeArea(.all)
        VStack {
          Text("Get Ready!")
            .foregroundStyle(Color.white)
            .font(.custom("Barlow-BlackItalic", size: 55))
            .padding(.bottom, -10)
          Text("\(audio.countdown)")
            .font(.custom("Barlow-BlackItalic", size: 250))
            .foregroundStyle(Color.white)
            .padding(.bottom, 130)
        }
      }
      
      if fingerButtonPressed{
        Color.black
          .opacity(0.85)
          .edgesIgnoringSafeArea(.all)

        ZStack{
          RoundedRectangle(cornerRadius: 10)
            .fill(Color(red: 0.25, green: 0.25, blue: 0.25))
            .frame(width: 310, height: 420)
         
          VStack {
            Image("left_hand_view")
              .resizable()
              .scaledToFit()
              .frame(width: 246, height: 246)
              .scaleEffect(1.0)
            
            Text("Left Hand View")
              .font(.custom("Barlow-Bold", size: 20))
              .foregroundColor(Color.white)
              .padding(.top, 20)
          }
          .padding()
          
          Button(action: {
            fingerButtonPressed = false
          }){
            Image(systemName: "xmark")
              .foregroundColor(.white)
              .font(.system(size: 34))
              .padding(.bottom, 340)
              .padding(.leading, 240)
          }
          .padding()
        }
      }
      
      if holdingButtonPressed{
        ZStack(alignment: .topTrailing) { 
          Color.black
            .opacity(0.95)
            .edgesIgnoringSafeArea(.all)
  
          VStack{
            Text("Hold your guitar\nlike the image")
              .font(.custom("Barlow-Bold", size: 24))
              .foregroundColor(Color.white)
              .padding(.top, 10)
              .padding(.bottom, 20)
              .multilineTextAlignment(.center)
            
            Image("guitar_holding_guide")
              .frame(width: 347)
                        
            Text("** Mirror View ** \n For Right Handed People")
              .font(.custom("Barlow-Bold", size: 16))
              .padding(.top, 30)
              .foregroundColor(Color.white)
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)

          Button(action: {
            holdingButtonPressed = false
          }){
            Image(systemName: "xmark")
              .foregroundColor(.white)
              .font(.system(size: 34))
          }
          .padding()
        }
      }
    }
  }

  func startCountdown() {
    audio.startCountdown()
  }

  func startDuration() {
    audio.startDuration()
  }
  
  private func requestMicrophoneAccess() {
    audio.requestMicrophoneAccess()
  }
}


