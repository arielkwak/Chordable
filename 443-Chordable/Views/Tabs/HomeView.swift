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
          Text("Random Quote")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .padding(.leading, 25)
        }.padding(.bottom, 80)
        
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
        }

      }.background(Color.black.edgesIgnoringSafeArea(.all))
    }
  }
}
