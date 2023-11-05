//
//  _43_ChordableApp.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

// _43_ChordableApp.swift
// _43_ChordableApp.swift
import SwiftUI

@main
struct _43_ChordableApp: App {
    let persistenceController = PersistenceController.shared
    @ObservedObject var onboardingState = OnboardingState() // Changed to @ObservedObject

    var body: some Scene {
        WindowGroup {
            if onboardingState.hasCompletedOnboarding {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                WelcomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(onboardingState)
            }
        }
    }
}


class OnboardingState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
    }
}
