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
      // Background
      Color.black.edgesIgnoringSafeArea(.all)
      
      // Content
      VStack(spacing: 30) {
        
        // Chord Button
        Button(action: {}) {
          VStack {
            HStack {
              // Split the chord name into parts for independent styling
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
                // Apply the offset to the sharp symbol only
                  .offset(x: -5, y: -10)
              }
            }
            // Center the chord quality text
            Text(chord.quality ?? "")
              .font(.custom("Barlow-Regular", size: 24))
              .fontWeight(.semibold)
              .foregroundColor(.white)
              .padding(.horizontal, 10) // Add horizontal padding to prevent text clipping
          }
          // Padding inside the VStack to ensure space around the content
          .padding(.horizontal, 30) // Horizontal padding for the entire VStack
          .padding(.vertical, 5) // Vertical padding for the entire VStack
          .padding(.bottom, 10)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 36 / 255.0, green: 0, blue: 255 / 255.0), Color(red: 127 / 255.0, green: 0, blue: 255 / 255.0)]), startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.bottom, 10)
        .padding(.top, 50)
        .disabled(true) // Disabled state is still here
        
        if isSuccess {
          VStack{
            Image("congrats_emoji") // Your image asset for success
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100) // Adjust the size as needed
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
                .foregroundColor(.black) // Set text color to black
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
    .navigationBarTitle("Result", displayMode: .inline)
  }
}
