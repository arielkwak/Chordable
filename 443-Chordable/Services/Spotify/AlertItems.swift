//
//  AlertItems.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 11/21/23.
//  Required for alerts, from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Project%20Utilities/AlertItem.swift

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    
    let id = UUID()
    let title: Text
    let message: Text
    
    init(title: String, message: String) {
        self.title = Text(title)
        self.message = Text(message)
    }
    
    init(title: Text, message: Text) {
        self.title = title
        self.message = message
    }

}
