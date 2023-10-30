//
//  TabView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI

struct MainTabView: View {
    
  @State private var selectedTab: Int = 0  // To keep track of the currently selected tab


    var body: some View {
      TabView {
          // Home Tab
          HomeView()
              .tabItem {
                  Image(systemName: "house.fill")
                  Text("Home")
              }
          
          // Chords Tab
          ChordsView(viewController: ChordsViewController())
              .tabItem {
                  Image(systemName: "music.note")
                  Text("Chords")
              }
          
          // Songs Tab
          SongsView()
              .tabItem {
                  Image(systemName: "music.mic")
                  Text("Songs")
              }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
