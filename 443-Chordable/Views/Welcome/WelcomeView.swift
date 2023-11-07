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
      ScrollView {
          ZStack {
              // Start with a black background
              Color.black.edgesIgnoringSafeArea(.all)

              // Place your image on top of the black background
              Image("start_page_background_image")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .edgesIgnoringSafeArea(.all)

              // Create a gradient from black to transparent that overlays the image
              let gradient = Gradient(colors: [Color.black, Color.black.opacity(0.6), Color.clear])
              let linearGradient = LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)

              // Place the gradient on top of the image
              linearGradient.edgesIgnoringSafeArea(.all)

              VStack(alignment: .leading, spacing: 16) {
                  // Welcome texts
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


                  // TextField placed higher on the screen
                  ZStack(alignment: .bottomLeading) {
                      Rectangle()
                          .frame(height: 6) // Height of the underline
                          .foregroundColor(.white) // Color of the underline
                          .cornerRadius(3) // This will make the ends of the Rectangle a bit more curvy.
                          .padding(.trailing, 30) // This will prevent it from extending all the way to the right.

                      TextField("", text: $userName)
                          .font(.custom("Barlow-Regular", size: 18))
                          .foregroundColor(.white)
                          .italic() // Italicized placeholder text
                          .placeholder(when: userName.isEmpty) {
                              Text("Enter your name").foregroundColor(.white).opacity(0.7).italic()
                          }
                          .padding(.bottom, 15) // This will move the text up a bit, so it doesn't overlap the underline.
                          .padding(.trailing, 30) // This will align the TextField text with the padded Rectangle underline.
                  }

                  
                  // Conditional display of the 'Continue' button
                  if !userName.isEmpty {
                      HStack {
                          Text("Continue")
                              .fontWeight(.bold)
                              .foregroundColor(.white)
                          Image(systemName: "arrow.right") // Sideways caret
                              .foregroundColor(.white)
                      }
                      .onTapGesture {
                          addUserAndContinue()
                      }
                      .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                      .padding(.horizontal)
                  }
                  
                  Spacer() // This spacer pushes the content towards the top, leaving space at the bottom.
              }
              .padding(.top, UIApplication.shared.connectedScenes
                  .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                  .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0 + 20) // Additional top padding to respect the safe area and additional space
              .padding(.leading, 30)
          }
          .navigationBarHidden(true)
      }.edgesIgnoringSafeArea(.all)
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

// WelcomeView.swift
// Add your existing WelcomeView code here.
//
//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(OnboardingState()) // Make sure to provide this if your view relies on it
//    }
//}
