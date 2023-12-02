//
//  SongsView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
// 

import SwiftUI
import CoreData

struct SongsView: View {
    let genres = ["Pop", "Rock", "R&B / Soul", "Folk & Country", "Alternative"]
    @Environment(\.managedObjectContext) var context

    var body: some View {
        NavigationView {
            VStack {

                List(genres, id: \.self) { genre in
                    NavigationLink(destination: SongsForGenreView(controller: SongsForGenreViewController(context: context, genre: genre))) {
                        Text(genre)
                    }
                }
                .padding(.top, 30)
            }
            .navigationTitle("Songs")
        }
    }
}
