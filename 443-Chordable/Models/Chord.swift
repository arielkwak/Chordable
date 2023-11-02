//
//  Chord.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//
import Foundation
import CoreData
extension Chord {
    static func fetchChords(filteredBy difficulty: String? = nil, completed: Bool? = nil, searchText: String? = nil) -> NSFetchRequest<Chord> {
        let request: NSFetchRequest<Chord> = Chord.fetchRequest()
        var predicates: [NSPredicate] = []
        if let difficulty = difficulty {
            predicates.append(NSPredicate(format: "difficulty == %@", difficulty))
        }
        
        if let completed = completed {
            // Using %d and treating the boolean as an Int (1 or 0)
            predicates.append(NSPredicate(format: "completed == %d", completed ? 1 : 0))
        }
        
        if let searchText = searchText, !searchText.isEmpty {
            let components = searchText.split(separator: " ")
            
            var combinedPredicates: [NSPredicate] = []
            
            for component in components {
              let searchString = String(component)
              let chordNamePredicate = NSPredicate(format: "displayable_name CONTAINS[cd] %@", searchString)
              let qualityPredicate = NSPredicate(format: "quality CONTAINS[cd] %@", searchString)
              
              let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [chordNamePredicate, qualityPredicate])
              combinedPredicates.append(orPredicate)
          }
            
            let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: combinedPredicates)
            predicates.append(andPredicate)
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "chord_name", ascending: true)]
        
        return request
    }
}


