//
//  Song.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import Foundation
import CoreData

extension Song {
    static func filterSongs(songs: [Song], searchText: String, tabSelection: Int) -> [Song] {
        return songs.filter { song in
            let matchesSearchText = searchText.isEmpty || (song.title?.lowercased().contains(searchText.lowercased()) ?? false)
            let isUnlocked = song.unlocked
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
    static func updateLockedSongs(context: NSManagedObjectContext) {
        let songRequest: NSFetchRequest<Song> = Song.fetchRequest()
        do {
            let songs = try context.fetch(songRequest)
            for song in songs {
                let chords = song.getUniqueChords(context: context)
                let isUnlocked = chords.allSatisfy { $0.completed }
                song.unlocked = isUnlocked
            }
            try context.save()
        } catch {
            print("Error updating locked songs: \(error)")
        }
    }
  }
