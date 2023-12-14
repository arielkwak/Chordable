//
//  SongCellView.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 12/4/23.
//

import SwiftUI
import Foundation
import SpotifyWebAPI
import Combine

struct SongCellView: View {
  @EnvironmentObject var spotify: Spotify
  @State private var alert: AlertItem? = nil
  @State private var image = Image("spotify album placeholder")
  @State private var loadImageCancellable: AnyCancellable? = nil
  @State private var trackCancellable: AnyCancellable? = nil
  @State private var albumCancellable: AnyCancellable? = nil
  @State private var didRequestImage = false
  @State private var albumURI: String?
  @State private var album: Album?
  
  
  let song: Song
  
  init(song: Song) {
    self.song = song
  }
  
  var body: some View {
    HStack {
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 63, height: 63)
        .clipped()
      
    }
    .onAppear(perform: loadImage)
  }
  
  func getTrack(songURI: String) -> AnyPublisher<Track, Error> {
    return spotify.api.track(songURI)
  }
  
  func getAlbum(albumURI: String) -> AnyPublisher<Album, Error> {
    return spotify.api.album(albumURI)
  }
  
  func loadImage() {
    
    if self.didRequestImage { return }
    self.didRequestImage = true
    
    if let songURI = song.uri {
      self.trackCancellable = getTrack(songURI: songURI)
        .flatMap { track in
          return getAlbum(albumURI: track.album?.uri ?? "")
        }
        .sink(receiveCompletion: { completion in
        }, receiveValue: { album in
          self.album = album
          
          guard let spotifyImage = self.album?.images?.largest else {
            print("Did not find album image")
            return
          }
          self.loadImageCancellable = spotifyImage.load()
            .receive(on: RunLoop.main)
            .sink(
              receiveCompletion: { _ in },
              receiveValue: { image in
                self.image = image
              }
            )
          
        })
    }
      
  }
  
}

