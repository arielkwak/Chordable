//
//  SongsForGenreViewController.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

// SongsForGenreViewController.swift

import Foundation
import CoreData

class SongsForGenreViewController: ObservableObject {
  
    @Published var songs: [Song] = []
    @Published var filteredSongs: [Song] = []
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""

    let context: NSManagedObjectContext
    let genre: String

    init(context: NSManagedObjectContext, genre: String) {
        self.context = context
        self.genre = genre
        fetchSongs(forGenre: genre)
    }

    var sortedSongs: [Song] {
        filteredSongs.sorted { ($0.title ?? "") < ($1.title ?? "") }
    }

    private func fetchSongs(forGenre genre: String) {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "genre == %@", genre)
        do {
            songs = try context.fetch(request)
            applyFilters()
        } catch {
            print("Error fetching songs for genre \(genre): \(error)")
        }
    }

    func applyFilters() {
        filteredSongs = Song.filterSongs(songs: songs, searchText: searchText, tabSelection: selectedTab)
    }
}


