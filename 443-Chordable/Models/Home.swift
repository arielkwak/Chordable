//
//  Home.swift
//  443-Chordable
//
//  Created by Ariel Kwak on 11/30/23.
//

import Foundation
class HomeModel: ObservableObject {
    
    @Published var lastOpened: Date?
    @Published var streak: Int = 0

    init() {
    }

    func appOpened() {
        print("Entered appOpened function")
        let now = Date()
        if let lastOpened = lastOpened {
            let calendar = Calendar.current
            if calendar.isDateInYesterday(lastOpened) {
                streak += 1
            } else if !calendar.isDateInToday(lastOpened) {
                streak = 1
            }
        } else {
            streak = 1
        }
        print("\(streak)")
        lastOpened = now

    }
}
