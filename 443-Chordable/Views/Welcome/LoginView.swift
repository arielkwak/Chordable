//
//  LoginView.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 11/21/23.
//  Login view from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Views/LoginView.swift

import SwiftUI
import Combine

/**
 A view that presents a button to login with Spotify.

 It is presented when `isAuthorized` is `false`.

 When the user taps the button, the authorization URL is opened in the browser,
 which prompts them to login with their Spotify account and authorize this
 application.

 After Spotify redirects back to this app and the access and refresh tokens have
 been retrieved, dismiss this view by setting `isAuthorized` to `true`.
 */
struct LoginView: ViewModifier {

    /// Always show this view for debugging purposes. Most importantly, this is
    /// useful for the preview provider.
    fileprivate static var debugAlwaysShowing = false
    
    /// The animation that should be used for presenting and dismissing this
    /// view.
    static let animation = Animation.spring()
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var spotify: Spotify

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// After the app first launches, add a short delay before showing this view
    /// so that the animation can be seen.
    @State private var finishedViewLoadDelay = false
    
    func body(content: Content) -> some View {
      ZStack {
        if !spotify.isAuthorized || Self.debugAlwaysShowing {
          Color.black.edgesIgnoringSafeArea(.all)
          Image("start_page_background_image")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .edgesIgnoringSafeArea(.all)
          
          let gradient = Gradient(colors: [Color.black, Color.black.opacity(0.6), Color.clear])
          let linearGradient = LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
          
          linearGradient.edgesIgnoringSafeArea(.all)
          if self.finishedViewLoadDelay || Self.debugAlwaysShowing {
            loginView
          }
        }
      }
      .onAppear {
        // After the app first launches, add a short delay before
        // showing this view so that the animation can be seen.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(LoginView.animation) {
            self.finishedViewLoadDelay = true
          }
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
    
    var loginView: some View {
        spotifyButton
            .overlay(retrievingTokensView)
    }
    
    var spotifyButton: some View {
      VStack{
        VStack(alignment: .leading, spacing: 16){
          Text("Connect to Spotify")
            .font(.custom("Barlow-Bold", size: 35))
            .foregroundColor(.white)
            .padding(.top, 10)
            .padding(.bottom, 5)
            .padding(.leading, 20)
          
          Text("To get started, we need to connect to your Spotify account")
            .font(.custom("Barlow-Regular", size: 20))
            .foregroundColor(.white)
            .padding(.bottom, 70)
            .padding(.horizontal, 20)
        }
        
        Image("spotify logo green")
          .resizable()
          .frame(width: 180, height: 180)
          .padding(.bottom, 70)
        
        Button(action: spotify.authorize) {
          HStack {
            Text("Connect to Spotify")
              .font(.custom("Barlow-Medium", size: 20))
              .padding(.horizontal, 25)
          }
          .padding()
          .background(.white)
          .clipShape(Capsule())
          .shadow(radius: 5)
        }
        .accessibility(identifier: "Connect to Spotify Identifier")
        .buttonStyle(PlainButtonStyle())
        // Prevent the user from trying to login again
        // if a request to retrieve the access and refresh
        // tokens is currently in progress.
        .allowsHitTesting(!spotify.isRetrievingTokens)
        .padding(.bottom, 5)
      }.offset(y: -90)
    }
    
    var retrievingTokensView: some View {
        VStack {
            Spacer()
            if spotify.isRetrievingTokens {
                HStack {
                    ProgressView()
                        .padding()
                    Text("Authenticating")
                }
                .padding(.bottom, 20)
            }
        }
    }
    
}
