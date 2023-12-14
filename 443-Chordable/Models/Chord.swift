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
          predicates.append(NSPredicate(format: "completed == %d", completed ? 1 : 0))
      }

      if let searchText = searchText, !searchText.isEmpty {
          let searchTerms = searchText.components(separatedBy: " ").filter { !$0.isEmpty }
          let lastCharacterIsSpace = searchText.last == " "
          let singleSearchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

          if singleSearchTerm.count == 1 {
              if lastCharacterIsSpace {
                  let chordNamePredicate = NSPredicate(format: "displayable_name ==[cd] %@", singleSearchTerm)
                  predicates.append(chordNamePredicate)
              } else {
                  let chordNamePredicate = NSPredicate(format: "displayable_name BEGINSWITH[cd] %@", singleSearchTerm)
                  predicates.append(chordNamePredicate)
              }
          } else if searchTerms.count > 1 {
              
              let namePredicate = NSPredicate(format: "displayable_name ==[cd] %@", searchTerms[0])
              let qualityComponents = Array(searchTerms[1...]) // Take the remaining terms as 'quality'.
              let qualityPredicates = qualityComponents.map { NSPredicate(format: "quality CONTAINS[cd] %@", $0) }
              let combinedQualityPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: qualityPredicates)
              let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, combinedQualityPredicate])
              predicates.append(andPredicate)
          } else {
              
              let namePredicate = NSPredicate(format: "displayable_name BEGINSWITH[cd] %@", singleSearchTerm)
              predicates.append(namePredicate)
          }
      }

      if !predicates.isEmpty {
          request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
      }

      request.sortDescriptors = [NSSortDescriptor(key: "chord_name", ascending: true)]

      return request
  }




}


