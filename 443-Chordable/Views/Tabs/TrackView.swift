////
////  TrackView.swift
////  443-Chordable
////
////  Created by Minjoo Kim on 11/28/23.
//// Adapted from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Views/TrackView.swift
//
//import SwiftUI
//import Combine
//import SpotifyWebAPI
//
//struct TrackView: View {
//    
//    @EnvironmentObject var spotify: Spotify
//    @State private var playRequestCancellable: AnyCancellable? = nil
//    @State private var alert: AlertItem? = nil
//    @State private var searchCancellable: AnyCancellable? = nil
//    @State var tracks: [Track] = []
////    @State var track: Track
//    
//    var body: some View {
//      Button(action: spotify.main) {
//        Text("JSON")
//      }
//        Button(action: playTrack) {
//            HStack {
////                Text(trackDisplayName())
//                Spacer()
//                Text("Last Christmas - Wham!")
//                Spacer()
//            }
//            // Ensure the hit box extends across the entire width of the frame.
//            // See https://bit.ly/2HqNk4S
//            .contentShape(Rectangle())
//        }
//        .buttonStyle(PlainButtonStyle())
//        .alert(item: $alert) { alert in
//            Alert(title: alert.title, message: alert.message)
//        }
//    }
//    
////    /// The display name for the track. E.g., "Eclipse - Pink Floyd".
////    func trackDisplayName() -> String {
////      // added for dev -- search for song given name and artist
////      let queryText = "Last Christmas Wham!"
////      self.searchCancellable = spotify.api.search(query: queryText, categories: [.track])
////        .receive(on: RunLoop.main)
////        .sink(
////          receiveCompletion: { completion in
////              if case .failure(let error) = completion {
////                  self.alert = AlertItem(
////                      title: "Couldn't Perform Search",
////                      message: error.localizedDescription
////                  )
////              }
////          },
////          receiveValue: { searchResults in
////              self.tracks = searchResults.tracks?.items ?? []
////              print("received \(self.tracks.count) tracks")
////          }
////          
////        )
////        var track = tracks.first!
////        var displayName = track.name
////        return displayName
////    }
//    
//    func playTrack() {
//        
//        let alertTitle = "Couldn't Play Song"
//        let trackURI = "spotify:track:2FRnf9qhLbvw8fu4IBXx78"
//
////        guard let trackURI = track.uri else {
////            self.alert = AlertItem(
////                title: alertTitle,
////                message: "missing URI"
////            )
////            return
////        }
//
//        let playbackRequest: PlaybackRequest
//        let albumURI = "spotify:album:6egzU9NKfora01qaNbvwfZ"
//        // Play the track in the context of its album. Always prefer
//        // providing a context; otherwise, the back and forwards buttons may
//        // not work.
//        playbackRequest = PlaybackRequest(
//            context: .contextURI(albumURI),
//            offset: .uri(trackURI)
//        )
//        
////        else {
////            playbackRequest = PlaybackRequest(trackURI)
////        }
////        
//        // By using a single cancellable rather than a collection of
//        // cancellables, the previous request always gets cancelled when a new
//        // request to play a track is made.
//        self.playRequestCancellable =
//            self.spotify.api.getAvailableDeviceThenPlay(playbackRequest)
//                .receive(on: RunLoop.main)
//                .sink(receiveCompletion: { completion in
//                    if case .failure(let error) = completion {
//                        self.alert = AlertItem(
//                            title: alertTitle,
//                            message: error.localizedDescription
//                        )
//                    }
//                })
//        
//    }
//}
