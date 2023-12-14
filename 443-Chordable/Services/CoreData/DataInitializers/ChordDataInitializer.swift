//
//  ChordDataInitializer.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import CoreData

class ChordDataInitializer {
    
    enum Difficulty: Int, CaseIterable {
        case easy, medium, hard
        
        var chords: [String] {
            switch self {
            case .easy: return ["A", "Am", "C", "D", "Dm", "E", "Em", "G"]
            case .medium: return ["F", "Fm", "F#", "F#m", "Gm", "G#", "G#m"]
            case .hard: return ["A#", "A#m", "B", "Bm", "Cm", "C#", "C#m", "D#", "D#m"]
            }
        }
        
        var description: String {
            switch self {
            case .easy: return "easy"
            case .medium: return "medium"
            case .hard: return "hard"
            }
        }
    }
    
    func initializeChordData(into context: NSManagedObjectContext) {
        for difficulty in Difficulty.allCases {
            for chord in difficulty.chords {
                
                let quality: String = chord.hasSuffix("m") ? "Minor" : "Major"
                
                let chord_instance = Chord(context: context)
                chord_instance.chord_id = UUID()
                chord_instance.chord_name = chord
                chord_instance.quality = quality
                chord_instance.difficulty = difficulty.description
                chord_instance.completed = false
                
                if chord.hasSuffix("m") {
                    chord_instance.displayable_name = String(chord.dropLast())
                } else {
                    chord_instance.displayable_name = chord
                }
                
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed to save context after importing: \(error)")
        }
    }
    
}
