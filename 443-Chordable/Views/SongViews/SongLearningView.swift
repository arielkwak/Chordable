//
//  SongLearningView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//  Referenced playback code from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Views/TrackView.swift

import SwiftUI
//import SpotifyWebAPI
//import Combine

struct SongLearningView: View {
    @ObservedObject var controller: SongLearningViewController
    @EnvironmentObject var spotify: Spotify
    @State private var alert: AlertItem? = nil
    let song: Song
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
          HStack{
            VStack{
              // song title
              Text(controller.song.title ?? "No title")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding(.leading, 25)
                .font(.custom("Barlow-Bold", size: 24))
                .padding(.top, 15)
              
              // artists
              Text(controller.song.artist ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding(.leading, 25)
                .font(.custom("Barlow-SemiBold", size: 16))
              
              // Chords needed
              Text("Chords: "+song.getUniqueChords(context: context).map { $0.chord_name ?? "Unknown Chord" }.joined(separator: ", "))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(red: 161 / 255, green: 161 / 255, blue: 161 / 255))
                .padding(.leading, 25)
                .padding(.top, 2)
                .font(.custom("Barlow-Regular", size: 16))
            }

            Spacer()
            
            // play along toggle 
            VStack(alignment: .trailing) {
              Text("Play along!")
                .foregroundColor(.white)
                .font(.custom("Barlow-Regular", size: 16))
              Toggle(isOn: $controller.playAlong) {
                EmptyView()
              }
              .toggleStyle(GradientToggleStyle())
              .disabled(!controller.isAtStartingPosition) // Disable the toggle if not at starting position
              .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 25)
            .padding(.top, 15)
          }
          .padding(.bottom, 35)
            
          // switch text
          if let secondsToNextChord = controller.secondsToNextChord {
            Text("Switch in \(String(format: "%.1f", secondsToNextChord)) second(s)") // Updated line
              .font(.headline)
              .font(.custom("Barlow-Bold", size: 32))
              .foregroundColor(.white)
              .padding(.bottom, 15)
          }
        
          // Display the current chord
          let chordName = controller.currentChords[0]?.chord?.chord_name ?? "No\nChord"
          let isLongChordName = chordName.count > 2
          Text(chordName)
            .font(.custom("Barlow-BlackItalic", size: chordName == "No\nChord" ? 45 : (isLongChordName ? 76 : 96)))
          .foregroundColor(.white)
          .multilineTextAlignment(.center)
          .frame(width: isLongChordName ? 200 : 175, height: 175)
          .background(Color.clear)
          .overlay(
            Circle()
              .stroke(
                LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255, green: 0, blue: 255 / 255, opacity: 1), Color(red: 127 / 255, green: 0, blue: 255 / 255, opacity: 1)]), startPoint: .leading, endPoint: .trailing),
                lineWidth: 4
              )
          ).padding(.bottom, 35)

          // Display the next three chords
          VStack(alignment: .leading){
            HStack {
              Text("Coming up chords")
                .foregroundColor(.white)
                .font(.custom("Barlow-Regular", size: 16))
              Spacer()
            }
            HStack {
              ForEach(1..<4) { index in
                let chordName = controller.currentChords[index]?.chord?.chord_name ?? "No\nChord"
                let isLongChordName = chordName.count > 2
                let fontSize = chordName == "No\nChord" ? 15 : (chordName.count > 2 ? 20 : 30)
                Text(chordName)
                  .font(.custom("Barlow-BlackItalic", size: CGFloat(fontSize)))
                  .foregroundColor(.white)
                  .multilineTextAlignment(.center)
                  .frame(width: 60, height: 60)
                  .background(Color.clear)
                  .overlay(
                    Circle()
                      .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255, green: 0, blue: 255 / 255, opacity: 1), Color(red: 127 / 255, green: 0, blue: 255 / 255, opacity: 1)]), startPoint: .leading, endPoint: .trailing),
                        lineWidth: 2
                      )
                  )
              }
              Spacer()
              Button(action: {
                  controller.restartSong()
              }) {
                  Image(systemName: "arrow.counterclockwise")
                      .foregroundColor(.white)
                      .padding()
                      .cornerRadius(30)
                      .font(.title)
              }
              .disabled(controller.isPlaying)
            }
            .padding(.horizontal, 25)
          }
          .padding(.bottom, 10)
          

          // Progress Bar
          ProgressBar(progress: controller.progress)
          
          // Play/Pause Button
          Button(action: controller.startPlayPause) {
            ZStack{
              Circle()
                .fill(Color.white)
                .frame(width: 60, height: 60)
              Image(systemName: controller.isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 30))
                .foregroundColor(Color(.black))
            }
          }
          .offset(y: -60)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }) {
            HStack {
              Image(systemName: "chevron.backward")
                  .foregroundColor(.white)
              Text("Songs")
                  .font(.custom("Barlow-Regular", size: 16))
                  .foregroundColor(.white)
          }
        })
    }
  
  
}


struct ProgressBar: View {
    var progress: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(red: 114 / 255, green: 114 / 255, blue: 114 / 255))
                    .cornerRadius(5)
                    .frame(height: 10)

                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(progress), height: 10)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding(.horizontal, 25)
    }
}




//struct ProgressBar: View {
//    var progress: Float
//
//    var body: some View {
//        ZStack(alignment: .leading) {
//            Rectangle()
//                .foregroundColor(Color(red: 114 / 255, green: 114 / 255, blue: 114 / 255))
//                .cornerRadius(5)
//            Rectangle()
//                .frame(width: CGFloat(self.progress) * UIScreen.main.bounds.width)
//                .foregroundColor(.white)
//                .cornerRadius(5)
//        }
//        .frame(height: 10)
//        .padding(.horizontal, 25)
//    }
//}

struct GradientToggleStyle: ToggleStyle {
  var colors: [Color] = [Color(red: 127 / 255, green: 0, blue: 255 / 255, opacity: 1), Color(red: 36 / 255, green: 0, blue: 255 / 255, opacity: 1)]
  var offColor: Color = Color.gray
  
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
      
      Button(action: { configuration.isOn.toggle() }) {
        if configuration.isOn {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
        } else {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(offColor)
        }
      }
      .frame(width: 50, height: 30)
      .overlay(
        Circle()
          .fill(Color.white)
          .padding(3)
          .offset(x: configuration.isOn ? 10 : -10)
      )
    }
  }
}
