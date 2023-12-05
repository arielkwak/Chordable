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
        .aspectRatio(contentMode: .fit)
        .cornerRadius(5)
      
    }
    .onAppear(perform: loadImage)
  }
  
  func getTrack(songURI: String) -> AnyPublisher<Track, Error> {
    return spotify.api.track(songURI)
//      .sink(receiveCompletion: { completion in
//        print("song URI completion for \(song.title):", completion, terminator: "\n\n\n")
//      }, receiveValue: { track in
//        print("song album URI:", track.album?.uri)
//        self.albumURI = track.album?.uri ?? ""
//      })
    
  }
  
  func getAlbum(albumURI: String) -> AnyPublisher<Album, Error> {
    return spotify.api.album(albumURI)
  }
  
  func loadImage() {
    // Return early if the image has already been requested. We can't just
    // check if `self.image == nil` because the image might have already
    // been requested, but not loaded yet.
    if self.didRequestImage { return }
    self.didRequestImage = true
    
    if let songURI = song.uri {
//      self.trackCancellable = spotify.api.track(songURI)
//        .sink(receiveCompletion: { completion in
//          print("song URI completion for \(song.title):", completion, terminator: "\n\n\n")
//        }, receiveValue: { track in
//          print("song album URI:", track.album?.uri)
//          self.albumURI = track.album?.uri ?? ""
//        })
      self.trackCancellable = getTrack(songURI: songURI)
        .flatMap { track in
          return getAlbum(albumURI: track.album?.uri ?? "")
        }
        .sink(receiveCompletion: { completion in
          print("album completion for \(song.title):", completion, terminator: "\n\n\n")
        }, receiveValue: { album in
          print("received album: \(album.name)")
          self.album = album
        })
      
//      self.albumCancellable = spotify.api.album(self.albumURI ?? "")
//        .sink(receiveCompletion: { completion in
//          print("album completion for \(song.title):", completion, terminator: "\n\n\n")
//        }, receiveValue: { album in
//          self.album = album
//        })
      
      guard let spotifyImage = album?.images?.largest else {
        print("No image :(")
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
    }
      
  }
  
}

