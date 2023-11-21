//
//  SongForGenresView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import SwiftUI

struct SongsForGenreView: View {
    @ObservedObject var controller: SongsForGenreViewController
    @Environment(\.managedObjectContext) var context

    var body: some View {
        List {
            ForEach(controller.sortedSongs, id: \.song_id) { song in
                NavigationLink(destination: SongLearningView(controller: SongLearningViewController(context: context, song: song))) {
                    Text(song.title ?? "Unknown Title")
                }
            }
        }
        .navigationTitle("Songs in \(controller.genre)")
    }
}
