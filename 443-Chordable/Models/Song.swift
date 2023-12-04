//
//  Song.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import Foundation
import CoreData

extension Song {
    func isUnlocked() -> Bool {
        // Logic to determine if the song is unlocked
        let allChordsCompleted = self.songChordInstances?.allSatisfy { instance in
            guard let chordInstance = instance as? SongChordInstance,
                  let chord = chordInstance.chord else { return false }
            return chord.completed
        } ?? false
        return allChordsCompleted
    }

    static func filterSongs(songs: [Song], searchText: String, tabSelection: Int) -> [Song] {
        return songs.filter { song in
            let matchesSearchText = searchText.isEmpty || (song.title?.lowercased().contains(searchText.lowercased()) ?? false)
            let isUnlocked = song.isUnlocked()
            return matchesSearchText && ((tabSelection == 0 && !isUnlocked) || (tabSelection == 1 && isUnlocked))
        }
    }

    func getUniqueChords(context: NSManagedObjectContext) -> [Chord] {
        print("Fetching unique chords for song: \(self.title ?? "Unknown Title")")

        guard let chordInstances = self.songChordInstances as? Set<SongChordInstance> else {
            print("No chord instances found for this song.")
            return []
        }

        let chordIDs = chordInstances.map { $0.chord?.chord_id }
        print("Chord IDs from SongChordInstances: \(chordIDs)")

        let uniqueChordIDs = Set(chordIDs.compactMap { $0 })
        print("Unique Chord IDs: \(uniqueChordIDs)")

        let fetchRequest: NSFetchRequest<Chord> = Chord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chord_id IN %@", uniqueChordIDs)

        do {
            let chords = try context.fetch(fetchRequest)
            print("Fetched Chords: \(chords.map { $0.displayable_name ?? "Unnamed Chord" })")
            return chords
        } catch {
            print("Error fetching chords: \(error)")
            return []
        }
    }
}
