//
//  SongsForGenreViewController.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import Foundation
import CoreData

class SongsForGenreViewController: ObservableObject {
  
    @Published var songs: [Song] = []
    let context: NSManagedObjectContext
    let genre: String  // Add this line to store the genre

    init(context: NSManagedObjectContext, genre: String) {
        self.context = context
        self.genre = genre  // Set the genre here
        fetchSongs(forGenre: genre)
    }

    private func fetchSongs(forGenre genre: String) {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "genre == %@", genre)

        do {
            songs = try context.fetch(request)
        } catch {
            print("Error fetching songs for genre \(genre): \(error)")
        }
    }
}

