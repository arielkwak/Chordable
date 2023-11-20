//
//  SongLearningView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import SwiftUI

struct SongLearningView: View {
    @ObservedObject var controller: SongLearningViewController

    var body: some View {
        NavigationView {
            List {
                ForEach(controller.songChordInstances, id: \.song_chord_instance_id) { instance in
                    NavigationLink(destination: ChordDetailView(chord: instance.chord!)) {
                        VStack(alignment: .leading) {
                            Text(instance.chord?.chord_name ?? "Unknown Chord")
                            Text("Start Time: \(instance.start_time)")
                            Text("End Time: \(instance.end_time)")
                        }
                    }
                }
            }
            .navigationTitle(controller.song.title ?? "Song Details")
        }
    }
}
