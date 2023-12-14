//
//  WelcomeView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/4/23.
//
// WelcomeView.swift

import SwiftUI
import SpotifyWebAPI
import Combine

struct WelcomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var onboardingState: OnboardingState
    @State var userName: String = ""
  
    @EnvironmentObject var spotify: Spotify
    @Binding var isAuthorized: Bool
    @State private var alert: AlertItem? = nil
    @State private var cancellables: Set<AnyCancellable> = []

  var body: some View {
    NavigationView {
      ScrollView {
        ZStack {
          Color.black.edgesIgnoringSafeArea(.all)
          
          Image("start_page_background_image")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
          
          let gradient = Gradient(colors: [Color.black, Color.black.opacity(0.6), Color.clear])
          let linearGradient = LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
          
          linearGradient.edgesIgnoringSafeArea(.all)
          
          VStack(alignment: .leading, spacing: 16) {
            Text("Welcome!")
              .font(.custom("Barlow-Regular", size: 50))
              .fontWeight(.semibold)
              .foregroundColor(.white)
              .padding(.top, 30)
            
            Text("Let's get you started")
              .font(.custom("Barlow-Regular", size: 20))
              .fontWeight(.semibold)
              .foregroundColor(.white)
              .padding(.bottom, 100)
            
          
            ZStack(alignment: .bottomLeading) {
              Rectangle()
                .frame(height: 6)
                .foregroundColor(.white)
                .cornerRadius(3)
                .padding(.trailing, 30)
              
              TextField("", text: $userName)
                .font(.custom("Barlow-Regular", size: 18))
                .foregroundColor(.white)
                .italic() // Italicized placeholder text
                .placeholder(when: userName.isEmpty) {
                  Text("Enter your name").foregroundColor(.white).opacity(0.7).italic()
                }
                .padding(.bottom, 15)
                .padding(.trailing, 30)
            }
            
          
            if !userName.isEmpty {
              NavigationLink(
                destination: SpotifyWelcomeView(userName: $userName, isAuthorized: $isAuthorized)) {
                  HStack {
                    Text("Continue")
                      .fontWeight(.bold)
                      .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                      .foregroundColor(.white)
                  }
                }
              
              
              .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
              .padding(.horizontal)
            }
            
            Spacer()
          }
          .padding(.top, UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0 + 20)
          .padding(.leading, 30)
        }
        .navigationBarHidden(true)
      }.edgesIgnoringSafeArea(.all)
    }
  }
  

}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

