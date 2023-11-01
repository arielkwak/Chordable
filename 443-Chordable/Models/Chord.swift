//
//  Chord.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import Foundation
import CoreData

extension Chord {
  // change to remove trail of 'm'
    var displayableName: String {
        return self.chord_name ?? "Unknown Chord"
    }

    static func fetchChords(filteredBy difficulty: String? = nil, completed: Bool? = nil) -> NSFetchRequest<Chord> {
        let request: NSFetchRequest<Chord> = Chord.fetchRequest()
        var predicates: [NSPredicate] = []

        if let difficulty = difficulty {
            predicates.append(NSPredicate(format: "difficulty == %@", difficulty))
        }
        
        if let completed = completed {
            // Using %d and treating the boolean as an Int (1 or 0)
            predicates.append(NSPredicate(format: "completed == %d", completed ? 1 : 0))
        }

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "chord_name", ascending: true)]
        
        return request
    }
}
