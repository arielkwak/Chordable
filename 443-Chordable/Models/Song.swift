//
//  Song.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import Foundation
import CoreData

class SongModel: ObservableObject {
    @NSManaged public var genre: String?
    @NSManaged public var unlocked: Bool

    init() {
    }

    static func fetchUnlockedSongsForGenre(context: NSManagedObjectContext, genre: String) -> Int {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "genre == %@ AND unlocked == true", genre)
        do {
            let songs = try context.fetch(fetchRequest)
            return songs.count
        } catch {
            print("Failed to fetch songs: \(error)")
            return 0
        }
    }
}
