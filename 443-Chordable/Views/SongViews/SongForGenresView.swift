//
//  SongForGenresView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import SwiftUI
import CoreData

struct SongsForGenreView: View {
    @ObservedObject var controller: SongsForGenreViewController
    @Environment(\.managedObjectContext) var context
    @State private var showingChordsOverlay = false
    @State private var selectedSong: Song?
    @State private var isNavigatingToSongLearning = false
    @State private var refreshView: Bool = false

    var body: some View {
        ZStack {
            VStack {
                // Search Bar
                TextField("Search Songs", text: $controller.searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // Segmented Picker for Locked/Unlocked
                Picker("Songs", selection: $controller.selectedTab) {
                    Text("Locked").tag(0)
                    Text("Unlocked").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Songs List
                List {
                    ForEach(controller.sortedSongs, id: \.song_id) { song in
                      SongCellView(song: song)
                        Button(action: {
                            handleSongSelection(song)
                        }) {
                            Text(song.title ?? "Unknown Title")
                        }
                    }
                }

                // Conditional NavigationLink for SongLearningView
                if isNavigatingToSongLearning, let song = selectedSong {
                    NavigationLink(
                        destination: SongLearningView(controller: SongLearningViewController(context: context, song: song)),
                        isActive: $isNavigatingToSongLearning
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
            .navigationTitle("Songs in \(controller.genre)")
            .onChange(of: controller.selectedTab) { _ in
                controller.applyFilters()
            }
            .onChange(of: controller.searchText) { _ in
                controller.applyFilters()
            }

            // Chords Overlay
            if showingChordsOverlay, let song = selectedSong {
                ChordsOverlayView(song: song, context: context, isPresented: $showingChordsOverlay)
            }
        }
        .id(refreshView) // Use the refreshView variable to force refresh the view
    }

    private func handleSongSelection(_ song: Song) {
        selectedSong = song
        if controller.selectedTab == 1 {
            isNavigatingToSongLearning = true
        } else {
            showingChordsOverlay = true
        }
    }
}

struct ChordsOverlayView: View {
    let song: Song
    let context: NSManagedObjectContext
    @Binding var isPresented: Bool
    @State private var selectedChord: Chord?
    @State private var isChordDetailActive = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Chords for \(song.title ?? "Unknown Song")").font(.headline)

                  ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(song.getUniqueChords(context: context), id: \.chord_id) { chord in
                            Button(action: {
                                self.selectedChord = chord
                                self.isChordDetailActive = true
                            }) {
                              Text(chord.chord_name ?? "Unknown Chord")
                                .foregroundColor(chord.completed ? .green : .red)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                  }

                    Button("Close") {
                        isPresented = false
                    }
                }
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.2)
                .background(Color.white)
                .cornerRadius(10)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                if let selectedChord = selectedChord {
                    NavigationLink(
                        destination: ChordDetailView(chord: selectedChord),
                        isActive: $isChordDetailActive
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }

                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 34))
                }
                .padding()
                .position(x: geometry.size.width - 20, y: 20) // Adjust as needed
            }
        }
    }
}
