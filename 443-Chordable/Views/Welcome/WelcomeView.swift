//
//  WelcomeView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/4/23.
//
// WelcomeView.swift

import SwiftUI

struct WelcomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var onboardingState: OnboardingState // Now using the shared state
    @State private var userName: String = ""

  var body: some View {
          NavigationView {
              VStack {
                  Text("Welcome")
                      .font(.largeTitle)
                      .padding()

                  TextField("Enter your name", text: $userName)
                      .textFieldStyle(RoundedBorderTextFieldStyle())
                      .padding()

                  if !userName.isEmpty {
                      Button("Continue") {
                          addUserAndContinue()
                      }
                      .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                  }
              }
              .navigationBarHidden(true)
              .background(
                  Image("start_page_background_image") // Use the exact name of your image asset
                      .resizable() // Make it resizable
                      .aspectRatio(contentMode: .fill) // Fill the available space
                      .edgesIgnoringSafeArea(.all) // Let the image extend into the safe area
              )
          }
      }

    private func addUserAndContinue() {
        let newUser = UserInfo(context: managedObjectContext)
        newUser.user_id = UUID()
        newUser.user_name = userName
        newUser.num_chords_completed = 0
        newUser.day_streak = 0
        newUser.num_songs_unlocked = 0

        do {
            try managedObjectContext.save()
            onboardingState.completeOnboarding() // Updates the shared onboarding state
        } catch {
            print("Could not save user: \(error)")
        }
    }
}


// WelcomeView.swift
// Add your existing WelcomeView code here.

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(OnboardingState()) // Make sure to provide this if your view relies on it
    }
}
