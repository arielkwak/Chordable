import Foundation
import SwiftUI
import CoreData

class ChordsViewController: ObservableObject {
    @Published var displayedChords: [Chord] = []
    @Published var filterOnCompleted: Bool = false {
        didSet {
            fetchChords()
        }
    }

    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    init() {
        fetchChords()
    }

    func fetchChords() {
        let request: NSFetchRequest<Chord> = Chord.fetchChords(completed: filterOnCompleted)
        do {
            displayedChords = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch chords: \(error)")
        }
    }
  
    func completeChord(_ chord: Chord) {
        chord.completed = true
        print("Chord completion state: \(chord.completed)")
        do {
            try viewContext.save()
            print("Chord updated and saved successfully")
        } catch {
            print("Failed to save completed state: \(error)")
        }
        fetchChords() // Refresh the chords
    }

}
