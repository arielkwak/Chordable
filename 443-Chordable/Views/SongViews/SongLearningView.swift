//
//  SongLearningView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import SwiftUI
import SpotifyWebAPI
import Combine

struct SongLearningView: View {
    @ObservedObject var controller: SongLearningViewController
    @EnvironmentObject var spotify: Spotify

    var body: some View {
        VStack {
            // Display the current chord
            Text(controller.currentChords[0]?.chord?.displayable_name ?? "No Chord")
                .font(.largeTitle)

            // Display the next three chords
            HStack {
                ForEach(1..<4) { index in
                    Text(controller.currentChords[index]?.chord?.displayable_name ?? "No Chord")
                }
            }

            // Play/Pause Button
            Button(action: controller.playPauseToggled) {
                Image(systemName: controller.isPlaying ? "pause.circle" : "play.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Toggle("Play along!", isOn: $controller.playAlong)
          
            // Progress Bar
            ProgressBar(progress: controller.progress)
        }
        .navigationTitle(controller.song.title ?? "Song Details")
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
