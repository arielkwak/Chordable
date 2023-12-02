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
  @EnvironmentObject var homeModel: HomeModel

  var body: some View {
    NavigationView {
      ScrollView{
        VStack(spacing: 10) {
          VStack {
            Text("GENRE PLAYLIST")
              .padding(.top,30)
              .padding(.bottom, 10)
              .font(.custom("Barlow-Bold", size: 32))
              .frame(maxWidth: .infinity, alignment: .leading)
              .kerning(1.6)
              .foregroundColor(.white)
              .padding(.leading, 25)
          }
          .background(Color.black)
          .padding(.bottom, 40)
          
          ZStack{
            Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 190/255, green: 180/255, blue: 255/255), Color.black]), startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .offset(y: -38)
            .edgesIgnoringSafeArea(.all)
            .shadow(color: Color(red: 0.14, green: 0, blue: 1).opacity(0.49), radius: 10, x: 0, y: -10)
            
            // Full rectangle with no corner radius
            Rectangle()
            .fill(Color(red: 35 / 255.0, green: 35 / 255.0, blue: 35 / 255.0))
            .edgesIgnoringSafeArea(.all)

            // Smaller rectangle with top corner radius
            Rectangle()
            .fill(Color(red: 35 / 255.0, green: 35 / 255.0, blue: 35 / 255.0))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .offset(y: -33)
            .edgesIgnoringSafeArea(.all)
            
            VStack{
              // song unlocked
              HStack{
                let songData = homeModel.fetchSongs(context: context)
                VStack{
                  CustomProgressBar(value: Float(songData.unlocked), total: Float(songData.total))
                    .padding(.top, 10)

                  HStack{
                    Spacer()
                    Text("\(songData.total) Songs")
                    .foregroundColor(.white)
                    .font(.custom("Barlow-Italic", size: 14))
                    .padding(.trailing, 35)
                  }

                  HStack{
                    Text("\(songData.unlocked)")
                    .foregroundColor(.white)
                    .font(.custom("Barlow-BlackItalic", size: 45))
                    .padding(.leading, 35)

                    Text("Songs Unlocked")
                    .foregroundColor(.white)
                    .font(.custom("Barlow-Italic", size: 16))
                    .padding(.leading, 5)
                    .padding(.top, 10)
                    
                    Spacer()
                  }.padding(.top, -20)
                }
              }
              .frame(maxWidth: .infinity)
              .frame(height: 120)
              .background(Color.black)
              .cornerRadius(15)
              .padding(.horizontal, 30)
              .padding(.bottom, 20)
              
              VStack{
                ForEach(genres, id: \.self) { genre in
                  NavigationLink(destination: SongsForGenreView(controller: SongsForGenreViewController(context: context, genre: genre))) {
                    if genre == "R&B / Soul" {
                      Image("R&B : Soul")
                      .resizable()
                      .frame(width:85, height:85)
                      .padding(.leading, 30)
                    } else {
                      Image("\(genre)")
                        .resizable()
                        .frame(width:85, height:85)
                        .padding(.leading, 30)
                    }
                    Text(genre)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .foregroundColor(.white)
                      .font(.custom("Barlow-Bold", size: 24))
                      .padding(.leading, 25)
                  }
                  .frame(height: 85)
                  .padding(.bottom, 25)
                }
              }
            }
          }
        }
      }.background(Color.black)
    }
  }
}
