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
  @Environment(\.managedObjectContext) var managedObjectContext
  @State var infoButtonPressed = false
  
  var body: some View {
    NavigationView {
      ZStack{
        VStack(spacing: 10) {
          VStack {
            HStack{
              if let user = userInfo.first {
                Text("Welcome, \(user.user_name ?? "User")")
                  .padding(.top,30)
                  .padding(.bottom, 10)
                  .font(.custom("Barlow-Bold", size: 32))
                  .foregroundColor(.white)
                  .padding(.leading, 25)
              } else {
                Text("Welcome")
                  .padding(.top,30)
                  .padding(.bottom, 10)
                  .font(.custom("Barlow-Bold", size: 32))
                  .foregroundColor(.white)
                  .padding(.leading, 25)
              }
              
              Spacer()
              
              Button(action: {
                infoButtonPressed = true
              }){
                Image(systemName: "info.circle.fill")
                  .foregroundStyle(.white)
                  .padding(.trailing, 25)
                  .padding(.top, 15)
                  .font(.system(size: 20))
              }
            }.padding(.horizontal, 10)

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
              .padding(.bottom, 10)

              // chord completion
              HStack{
                let (totalChords, completedChords) = homeModel.fetchChords(context: managedObjectContext) // Fetch chords and count completed ones
                let percentageCompleted = totalChords > 0 ? (completedChords * 100 / totalChords) : 0  // Calculate percentage

                CircularProgressView(progress: Double(percentageCompleted)/100.0)
                .frame(width: 120, height: 120)
                .padding(.leading, 35)

                Spacer()
                Text("Chords\nCompleted")
                  .foregroundColor(.white)
                  .font(.custom("Barlow-Italic", size: 24))
                  .multilineTextAlignment(.center)
                  .padding(.trailing, 35)
              }
              .frame(maxWidth: .infinity) 
              .frame(height: 180)
              .background(Color.black)
              .cornerRadius(15)
              .padding(.horizontal, 30)
              .padding(.bottom, 10)
              
              // song unlocked
              HStack{
                let songData = homeModel.fetchSongs(context: managedObjectContext)
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

                    Text("Song(s) Unlocked")
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
              
            }
            .offset(y: -30)
            .padding(.top, 20)
          }

        }.background(Color.black.edgesIgnoringSafeArea(.all))

        if infoButtonPressed {
          ZStack(alignment: .topTrailing) { 
            Color.black
              .opacity(0.95)
              .edgesIgnoringSafeArea(.all)
    
            VStack{
              Text("App Overview:")
                .font(.custom("Barlow-Bold", size: 30))
                .foregroundColor(Color.white)
                .padding(.top, 10)
                .multilineTextAlignment(.leading)
                .padding(.leading, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 30)
              
              Text("How to complete a chord:")
                .font(.custom("Barlow-Bold", size: 24))
                .foregroundColor(Color.white)
                .padding(.top, 10)
                .multilineTextAlignment(.leading)
                .padding(.leading, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
              
                          
              Text("Utilize our “try it” feature by clicking on the chord you want to complete. You will have 5 seconds to record yourself playing 1 strum if the desired chord, and the app will determine if you played it right. If you did, Congrats! You have completed the chord")
                .font(.custom("Barlow-Medium", size: 16))
                .padding(.top, 10)
                .padding(.horizontal, 25)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 30)
              
              Text("How to unlock songs:")
                .font(.custom("Barlow-Bold", size: 24))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading)
                .padding(.leading, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
              
              Text("Click on a locked song to find out what chords are needed for that song. Once you have completed all the chords in that song, you have unlocked it!")
                .font(.custom("Barlow-Medium", size: 16))
                .padding(.top, 10)
                .padding(.horizontal, 25)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button(action: {
              infoButtonPressed = false
            }){
              Image(systemName: "xmark")
                .foregroundColor(.white)
                .font(.system(size: 34))
            }
            .padding()
          }
        }
      }
    }
  }
}

struct CircularProgressView: View {
  var progress: Double

  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 20)
        .foregroundColor(Color.white)

      Circle()
        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
        .stroke(AngularGradient(gradient: Gradient(colors: [Color(red: 36/255, green: 0, blue: 255/255), Color(red: 127/255, green: 0, blue: 255/255), Color(red: 36/255, green: 0, blue: 255/255)]), center: .center), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
        .rotationEffect(Angle(degrees: 270.0))

      HStack{
        Text("\(Int(progress * 100))") 
            .font(.custom("Barlow-BlackItalic", size: 48))
            .foregroundColor(.white)

        Text("%")
            .font(.custom("Barlow-BlackItalic", size: 16))
            .foregroundColor(.white)
            .padding(.leading, -5)
            .padding(.top, 20)
      }
    }
  }
}

struct CustomProgressBar: View {
  var value: Float
  var total: Float

  var body: some View {
    ProgressView(value: value, total: total)
      .progressViewStyle(CustomProgressViewStyle())
      .frame(height: 15)
      .padding(.horizontal, 35)
  }
}

struct CustomProgressViewStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(Color.white)
          .frame(width: geometry.size.width, height: geometry.size.height)
        Rectangle()
          .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 36/255, green: 0, blue: 255/255), Color(red: 127/255, green: 0, blue: 255/255), Color(red: 36/255, green: 0, blue: 255/255)]), startPoint: .leading, endPoint: .trailing))
          .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: geometry.size.height)
          .animation(.easeIn, value: configuration.fractionCompleted)
      }
      .cornerRadius(10)
    }
  }
}
