//
//  HomeView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import SwiftUI
import CoreData

struct HomeView: View {
  @FetchRequest(
    entity: UserInfo.entity(),
    sortDescriptors: [],
    predicate: nil
  ) var userInfo: FetchedResults<UserInfo>

  let quotes = Quote.Quotes()
  @EnvironmentObject var homeModel: HomeModel
  
  var body: some View {
    NavigationView {
      VStack(spacing: 10) {
        VStack {
          if let user = userInfo.first {
            Text("Welcome, \(user.user_name ?? "User")")
              .padding(.top,30)
              .padding(.bottom, 10)
              .font(.custom("Barlow-Bold", size: 32))
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundColor(.white)
              .padding(.leading, 25)
          } else {
            Text("Welcome")
              .padding(.top,30)
              .padding(.bottom, 10)
              .font(.custom("Barlow-Bold", size: 32))
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundColor(.white)
              .padding(.leading, 25)
          }
          if let (artist, quote) = quotes.getRandomQuote(){
            (Text("“").font(.custom("Chango-Regular", size: 25)) +
            Text("\(quote)").font(.custom("Barlow-Italic", size: 20)) +
            Text("”").font(.custom("Chango-Regular", size: 25)))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 25)            
            .padding(.trailing, 10)
            
            Text("-\(artist)")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundColor(.white)
            .padding(.trailing, 25)
            .font(.custom("Barlow-Italic", size: 17))
          }
        }.padding(.bottom, 50)
        
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

          // MARK: Content within rectangle  
          VStack{
            // Streak
            HStack {
              Text("\(homeModel.streak)")
                .foregroundColor(.white)
                .font(.custom("Barlow-BlackItalic", size: 50))
                .padding(.leading, 35)
              Spacer()
              Text("Day (s)  Streak!")
                .foregroundColor(.white)
                .font(.custom("Barlow-Italic", size: 24))
                .padding(.leading, 5)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("🔥")
                .font(.custom("Barlow-Black", size: 45))
                .padding(.trailing, 35)
            }
            .frame(height: 90)
            .background(Color.black)
            .cornerRadius(15)
            .padding(.horizontal, 30)
            .offset(y: -190)
          }
        }

      }.background(Color.black.edgesIgnoringSafeArea(.all))
    }
  }
}
