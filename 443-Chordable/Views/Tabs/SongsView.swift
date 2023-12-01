//
//  SongsView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
// https://open.spotify.com/track/6wn2nmFn3wDuiMldRiuRuL?si=56b04b63d98d460a

import SwiftUI
import CoreData

struct SongsView: View {
    let genres = ["Pop", "Rock", "R&B / Soul", "Folk & Country", "Alternative"]
    @Environment(\.managedObjectContext) var context
//    @EnvironmentObject var spotify: Spotify

    var body: some View {
        NavigationView {
            VStack {

                List(genres, id: \.self) { genre in
                    NavigationLink(destination: SongsForGenreView(controller: SongsForGenreViewController(context: context, genre: genre))) {
                        Text(genre)
                    }
                }
                .padding(.top, 30)
              Spacer()
            }
            .navigationTitle("Songs")
        }
    }
}
