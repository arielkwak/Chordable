//
//  SongLearningViewController.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import Foundation
import CoreData

class SongLearningViewController: ObservableObject {
    @Published var songChordInstances: [SongChordInstance] = []
    private let context: NSManagedObjectContext
    var song: Song // Make this internal or public

    init(context: NSManagedObjectContext, song: Song) {
        self.context = context
        self.song = song
        fetchSongChordInstances()
    }

    private func fetchSongChordInstances() {
        let request: NSFetchRequest<SongChordInstance> = SongChordInstance.fetchRequest()
        request.predicate = NSPredicate(format: "song == %@", song)

        do {
            songChordInstances = try context.fetch(request)
        } catch {
            print("Error fetching song chord instances: \(error)")
        }
    }
}
