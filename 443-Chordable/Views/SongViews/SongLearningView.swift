//
//  SongLearningView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//  Referenced playback code from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Views/TrackView.swift

import SwiftUI
import SpotifyWebAPI
import Combine

struct SongLearningView: View {
    @ObservedObject var controller: SongLearningViewController
    @EnvironmentObject var spotify: Spotify
    @State private var playRequestCancellable: AnyCancellable? = nil
    @State private var pauseRequestCancellable: AnyCancellable? = nil
    @State private var alert: AlertItem? = nil
    let song: Song
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
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
              .font(.custom("Barlow-Regular", size: 16))
          }
          .padding(.bottom, 35)
            
          if let secondsToNextChord = controller.secondsToNextChord {
              Text("Switch chord in \(String(format: "%.1f", secondsToNextChord)) second(s)") // Updated line
                  .font(.headline)
                  .foregroundColor(.white)
          }
        
          // Display the current chord
          Text(controller.currentChords[0]?.chord?.displayable_name ?? "No Chord")
              .font(.largeTitle)
              .foregroundColor(.white)

          // Display the next three chords
          HStack {
              ForEach(1..<4) { index in
                  Text(controller.currentChords[index]?.chord?.displayable_name ?? "No Chord")
                  .foregroundColor(.white)
              }
          }

          // Play/Pause Button
          Button(action: startPlayPause) {
              Image(systemName: controller.isPlaying ? "pause.circle" : "play.circle")
                  .resizable()
                  .frame(width: 50, height: 50)
          }
          
          Toggle("Play along!", isOn: $controller.playAlong)
            .foregroundColor(.white)
        
          // Progress Bar
          ProgressBar(progress: controller.progress)
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
  
  func startPlayPause() {
    // if play along, then play
    if controller.playAlong {
      // if is paused, then play song
      // if is playing, then pause song
      if !controller.isPlaying {
        if controller.progress > 0 {
          resumeSong()
        } else {
          playSong()
        }
      } else {
        pauseSong()
      }
      // play/pause chords
      controller.playPauseToggled()
    } else {
      controller.playPauseToggled()
    }
  }
  
  func playSong() {
    let alertTitle = "Couldn't Play \(controller.song.title ?? "Song")"
    guard let trackURI = controller.song.uri else {
      self.alert = AlertItem(
                      title: alertTitle,
                      message: "missing URI"
        )
      return
    }
    let playbackRequest: PlaybackRequest
    playbackRequest = PlaybackRequest(trackURI)
    
    // By using a single cancellable rather than a collection of
    // cancellables, the previous request always gets cancelled when a new
    // request to play a track is made.
    self.playRequestCancellable =
        self.spotify.api.getAvailableDeviceThenPlay(playbackRequest)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.alert = AlertItem(
                        title: alertTitle,
                        message: error.localizedDescription
                    )
                }
            })
  }
  
  func pauseSong() {
    let alertTitle = "Couldn't Pause \(controller.song.title ?? "Song")"
    self.pauseRequestCancellable =
      self.spotify.api.pausePlayback()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.alert = AlertItem(
            title: alertTitle,
            message: error.localizedDescription)
        }
      })
  }
  
  func resumeSong() {
    let alertTitle = "Couldn't Resume \(controller.song.title ?? "Song")"
    self.playRequestCancellable = self.spotify.api.resumePlayback()
          .receive(on: RunLoop.main)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              self.alert = AlertItem(
                title: alertTitle,
                message: error.localizedDescription)
            }
          })
  }
}


struct ProgressBar: View {
    var progress: Float
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(width: geometry.size.width * CGFloat(progress), height: 10)
                .foregroundColor(.blue)
                .cornerRadius(5)
        }
    }
}
