//
//  _43_ChordableTests.swift
//  443-ChordableTests
//
//  Created by Minjoo Kim on 11/10/23.
//

import XCTest
@testable import _43_Chordable

final class _43_ChordableTests: XCTestCase {

    func testCompleteOnboarding() {
        let onboardingState = OnboardingState()

        onboardingState.completeOnboarding()
        XCTAssertTrue(onboardingState.hasCompletedOnboarding, "Onboarding should be marked as completed")
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasCompletedOnboarding"), "UserDefaults should reflect the completion of onboarding")
    }

    func testAppLaunchLogic() {
        let onboardingState = OnboardingState()
        let homeModel = HomeModel(context: PersistenceController.preview.container.viewContext)
        
        onboardingState.hasCompletedOnboarding = false
        XCTAssertFalse(homeModel.streak > 0, "Streak should be zero before app opened")

        homeModel.appOpened()
        XCTAssertTrue(homeModel.streak > 0, "Streak should be incremented after app opened")

        onboardingState.completeOnboarding()
        XCTAssertTrue(onboardingState.hasCompletedOnboarding, "Onboarding should be marked as completed after calling completeOnboarding")
    }
  
    func testWelcomeViewPresentationLogic() {
        let onboardingState = OnboardingState()
        let homeModel = HomeModel(context: PersistenceController.preview.container.viewContext)

        onboardingState.hasCompletedOnboarding = false
        homeModel.appOpened()
        XCTAssertFalse(onboardingState.hasCompletedOnboarding, "WelcomeView should be presented when onboarding is not completed")

        onboardingState.completeOnboarding()
        XCTAssertTrue(onboardingState.hasCompletedOnboarding, "WelcomeView should not be presented after completing onboarding")
    }
  

}
