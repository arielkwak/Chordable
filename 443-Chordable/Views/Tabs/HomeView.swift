//
//  HomeView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI

struct HomeView: View {
    // Assuming you have a way to fetch the current user's name. Placeholder for now.
    let userName: String = "John"

    var body: some View {
        VStack {
            Text("Welcome, \(userName)")
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .navigationTitle("Home")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
