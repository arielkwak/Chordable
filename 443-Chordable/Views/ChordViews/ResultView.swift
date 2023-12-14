//
//  ResultView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/9/23.
//

import SwiftUI

struct ResultView: View {
  let isSuccess: Bool
  let chord: Chord
  
  @Environment(\.presentationMode) var presentationMode
  
  @FetchRequest(
    entity: UserInfo.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.user_name, ascending: true)]
  ) var users: FetchedResults<UserInfo>
  
  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 30) {
        
        Button(action: {}) {
          VStack {
            HStack {
              let chordParts = (chord.displayable_name ?? "").components(separatedBy: "#")
              if let firstPart = chordParts.first {
                Text(firstPart)
                  .font(.custom("Barlow-BlackItalic", size: 75))
                  .foregroundColor(.white)
              }
              if chordParts.count > 1 {
                Text("#")
                  .font(.custom("Barlow-BlackItalic", size: 35))
                  .foregroundColor(.white)
                  .offset(x: -5, y: -10)
              }
            }
            Text(chord.quality ?? "")
              .font(.custom("Barlow-Regular", size: 24))
              .fontWeight(.semibold)
              .foregroundColor(.white)
              .padding(.horizontal, 10)
          }
          .padding(.horizontal, 30)
          .padding(.vertical, 5)
          .padding(.bottom, 10)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.bottom, 10)
        .padding(.top, 50)
        .disabled(true)
        
        if isSuccess {
          VStack{
            Image("congrats_emoji")
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .padding(.top, 20)
            
            Text("Complete!")
              .font(.custom("Barlow-BoldItalic", size: 60))
              .foregroundColor(.white)
              .padding(.top, 30)
          }
          
          Text("Congrats \(users.first?.user_name ?? "Default Name")!")
            .font(.custom("Barlow-Italic", size: 30))
            .foregroundColor(.white)

          
        }
        else {
          
          VStack{
            
            Text("Let's Try Again")
              .font(.custom("Barlow-BoldItalic", size: 40))
              .foregroundColor(.white)
              .padding(.top, 20)
            
            Text("You got this.")
              .font(.custom("Barlow-Italic", size: 30))
              .foregroundColor(.white)
              .padding(.top, 10)
              .padding(.bottom, 75)
            
            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
              Text("Try Again")
                .font(.custom("Barlow-SemiBold", size: 20))
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            }
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
          }
        }
        
        Spacer()
        
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: Button(action: {
        self.presentationMode.wrappedValue.dismiss()
      }) {
        HStack {
          Image(systemName: "chevron.backward")
              .foregroundColor(.white)
          Text("Back")
              .font(.custom("Barlow-Regular", size: 16))
              .foregroundColor(.white)
      }
    })
  }
}
