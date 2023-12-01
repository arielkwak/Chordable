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
            .padding(.top, 3)
          }
        }.padding(.bottom, 60)
        
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
            Rectangle()
            .fill(Color.black) 
            .frame(height: 50) 
            .cornerRadius(15)
            .overlay(
              Text("\(homeModel.streak)")
                  .foregroundColor(.white)
                  .onAppear {
                  print("HomeView appeared with streak: \(homeModel.streak)") // This will print the streak when HomeView appears
                }
            )
            .padding(.horizontal, 25) 
          }
        }

      }.background(Color.black.edgesIgnoringSafeArea(.all))
    }
  }
}
