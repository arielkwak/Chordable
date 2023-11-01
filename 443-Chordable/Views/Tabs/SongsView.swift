//
//  SongsView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI

struct SongsView: View {
    var body: some View {
      VStack {
          Text("Welcome, this is the songs tab")
              .font(.largeTitle)
              .padding()

          Spacer()
      }
      .navigationTitle("Home")
    }
}

struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView()
    }
}
