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
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  var body: some View {
    VStack(spacing: 10) {
      VStack {
        Text("\(controller.genre)")
          .padding(.top,90)
          .padding(.bottom, 10)
          .font(.custom("Barlow-Bold", size: 32))
          .frame(maxWidth: .infinity, alignment: .leading)
          .kerning(1.6)
          .foregroundColor(.white)
          .padding(.leading, 25)
      }
      .background(Color.black)
      
      ZStack {
        VStack {
          ZStack{
            Color.black
              .clipShape(RoundedRectangle(cornerRadius: 30))
              .shadow(color: Color(red: 0.14, green: 0, blue: 1).opacity(0.49), radius: 10, x: 0, y: -10)
            
            VStack{
              Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 190/255, green: 180/255, blue: 255/255), Color.black]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 5)
                .padding(.horizontal, 30)
              
              VStack{
                // Search Bar
                HStack {
                  Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                  
                  TextField("Search for songs...", text: $controller.searchText)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .font(Font.custom("Barlow-regular", size: 16))
                }
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                
                // Segmented Picker for Locked/Unlocked
                HStack{
                  // button styling for Unlocked
                  Button(action: {
                    controller.selectedTab = 1
                  }) {
                    Text("Unlocked")
                      .font(controller.selectedTab == 1 ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                      .padding(.trailing, 50)
                      .overlay { controller.selectedTab == 1 ?
                        LinearGradient(
                          colors: [Color(red: 36 / 255, green: 0, blue: 255 / 255), Color(red: 127 / 255, green: 0, blue: 255 / 255)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Unlocked")
                            .font(controller.selectedTab == 1 ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                            .padding(.trailing, 50)
                        )
                        :
                        LinearGradient(
                          colors: [Color(red: 0.63, green: 0.63, blue: 0.63), Color(red: 0.63, green: 0.63, blue: 0.63)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Unlocked")
                            .font(controller.selectedTab == 1 ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                            .padding(.trailing, 50)
                        )
                      }
                  }
                  
                  // button styling for Locked
                  Button(action: {
                    controller.selectedTab = 0
                  }) {
                    Text("Locked")
                      .font(controller.selectedTab == 0 ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                      .padding(.leading, 50)
                      .overlay { controller.selectedTab == 0 ?
                        LinearGradient(
                          colors: [Color(red: 36 / 255, green: 0, blue: 255 / 255), Color(red: 127 / 255, green: 0, blue: 255 / 255)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Locked")
                            .font(controller.selectedTab == 0 ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                            .padding(.leading, 50)
                        )
                        :
                        LinearGradient(
                          colors: [Color(red: 0.63, green: 0.63, blue: 0.63), Color(red: 0.63, green: 0.63, blue: 0.63)],
                          startPoint: .leading,
                          endPoint: .trailing
                        )
                        .mask(
                          Text("Locked")
                            .font(controller.selectedTab == 0 ? .custom("Barlow-Bold", size: 22) : .custom("Barlow-Regular", size: 22))
                            .padding(.leading, 50)
                        )
                      }
                  }
                }.padding([.leading, .trailing])
                
                // underline for buttons when pressed
                GeometryReader { geometry in
                  HStack {
                    Rectangle()
                      .fill(controller.selectedTab == 1 ?
                            AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing)) :
                              AnyShapeStyle(Color.clear)
                      )
                      .frame(width: geometry.size.width / 2, height: 5)
                    Spacer()
                    Rectangle()
                      .fill(controller.selectedTab == 0 ?
                            AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing)) :
                              AnyShapeStyle(Color.clear)
                      )
                      .frame(width: geometry.size.width / 2, height: 5)
                  }
                  .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .offset(y: 6)
              }
            }
          }
          
          // Songs List
          ScrollView{
            LazyVStack(alignment: .leading) {
              ForEach(controller.sortedSongs, id: \.song_id) { song in
                HStack {
                  SongCellView(song: song)
                  Button(action: {
                    handleSongSelection(song)
                  }) {
                    HStack{
                      VStack(alignment: .leading) {
                        Text((song.title ?? "Unknown Song").trimmingCharacters(in: .whitespacesAndNewlines))
                          .font(.custom("Barlow-Bold", size: 20))
                          .foregroundColor(.white)
                          .multilineTextAlignment(.leading)
                        
                        Text((song.artist ?? "Unknown Artist").trimmingCharacters(in: .whitespacesAndNewlines))
                          .foregroundColor(Color(red: 161 / 255, green: 161 / 255, blue: 161 / 255))
                          .font(.custom("Barlow-Regular", size: 16))
                          .multilineTextAlignment(.leading)
                      }
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .padding(.leading, 3)
                      
                      if controller.selectedTab == 0 {
                        Image("locked_icon")
                          .resizable()
                          .frame(width: 22, height: 27)
                          .padding(.horizontal, 5)
                      }
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 25)
                  }
                }.padding(.vertical, 5)
              }
            }
            .padding(.leading, 25)
            .padding(.top, 15)
            .padding(.bottom, 130)
          }
          .background(Color(red: 35 / 255.0, green: 35 / 255.0, blue: 35 / 255.0))
          .frame(minHeight: 520)
          
          // Conditional NavigationLink for SongLearningView
          if isNavigatingToSongLearning, let song = selectedSong {
            NavigationLink(
              destination: SongLearningView(controller: SongLearningViewController(context: context, song: song), song: song),
              isActive: $isNavigatingToSongLearning
            ) {
              EmptyView()
            }
            .hidden()
          }
        }
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
    .background(Color.black.edgesIgnoringSafeArea(.all))
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: Button(action: {
        self.presentationMode.wrappedValue.dismiss()
      }) {
        HStack {
          Image(systemName: "chevron.backward")
              .foregroundColor(.white)
          Text("Genre Playlists")
              .font(.custom("Barlow-Regular", size: 16))
              .foregroundColor(.white)
      }
    })
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
                  Text("Chords for \(song.title ?? "Unknown Song"):")
                    .font(.custom("Barlow-BoldItalic", size: 18))
                    
                    .foregroundStyle(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 3)
                    .padding(.leading, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)

                  ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(song.getUniqueChords(context: context), id: \.chord_id) { chord in
                          let chordName = chord.chord_name ?? "Unknown Chord"
                          let chordParts = chordName.components(separatedBy: "#")

                          Button(action: {
                            self.selectedChord = chord
                            self.isChordDetailActive = true
                          }) {
                            VStack {
                              VStack {
                                HStack{
                                  if let firstPart = chordParts.first {
                                    let firstChar = String(firstPart.prefix(1))
                                    Text(firstChar)
                                      .foregroundColor(.white)
                                      .font(.custom("Barlow-BlackItalic", size: 64))
                                      .fixedSize(horizontal: false, vertical: true)
                                  }
                                  if chordParts.count > 1 {
                                    Text("#")
                                      .foregroundColor(.white)
                                      .font(.custom("Barlow-BlackItalic", size: 32))
                                      .fixedSize(horizontal: false, vertical: true)
                                      .offset(x:-5, y: -10)
                                  }
                                }
                                Text(chordName.hasSuffix("m") ? "Minor" : "Major")
                                  .font(.custom("Barlow-Regular", size: 24))
                                  .foregroundColor(.white)
                                  .fixedSize(horizontal: false, vertical: true)
                                  .padding(.bottom, 8)
                            }
                            .frame(width: 114, height: 130)
                            .background(
                                ZStack {
                                  RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black)
                                  if chord.completed {
                                    RoundedRectangle(cornerRadius: 18)
                                      .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 36/255, green: 0, blue: 255/255), Color(red: 127/255, green: 0, blue: 255/255)]), startPoint: .top, endPoint: .bottom))
                                  }
                                }
                              )
                            }
                            .padding(.horizontal, 4)
                          }
                      }
                    }.padding(.horizontal, 10)
                  }

                  Button("Close") {
                      isPresented = false
                  }
                  .padding(.bottom, 10)
                  .foregroundStyle(.white)
                  .padding(.top, 3)
                  .font(.custom("Barlow-Bold", size: 18))
                }
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.35)
                .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                .cornerRadius(10)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)

               if let selectedChord = selectedChord {
                 NavigationLink(
                   destination: ChordDetailView(chord: selectedChord),
                   isActive: $isChordDetailActive
                 ) {
                   EmptyView()
                 }
                 .hidden()
               }
            }
        }
    }
}
