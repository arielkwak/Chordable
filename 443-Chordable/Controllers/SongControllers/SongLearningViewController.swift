//
//  SongLearningViewController.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import Foundation
import CoreData

class SongLearningViewController: ObservableObject {
    @Published var currentChords: [SongChordInstance?] = [nil, nil, nil, nil] // Current and next 3 chords
    @Published var isPlaying = false
    @Published var progress: Float = 0.0 // For progress bar

    private let context: NSManagedObjectContext
    private var timer: Timer?
    private var elapsedTime: Float = 0.0
    private var totalDuration: Float = 0.0
    var song: Song // Make this internal or public
    var songChordInstances: [SongChordInstance] = []

    init(context: NSManagedObjectContext, song: Song) {
        self.context = context
        self.song = song
        fetchSongChordInstances()
        calculateTotalDuration()
    }

    func playPauseToggled() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 0.1
            self.updateChords()
            self.updateProgress()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateProgress() {
        progress = elapsedTime / totalDuration
    }

    private func updateChords() {
        // Find the current chord based on elapsed time
        let currentChord = songChordInstances.first { instance in
            elapsedTime >= instance.start_time && elapsedTime <= instance.end_time
        }

        // Update the current chord
        currentChords[0] = currentChord

        // Define a variable for the time to search for upcoming chords
        let searchTime = currentChord == nil ? elapsedTime : currentChord!.end_time

        // Find and update the next three chords
        let upcomingChords = songChordInstances.filter { $0.start_time >= searchTime }
        for i in 1...3 {
            currentChords[i] = (i - 1) < upcomingChords.count ? upcomingChords[i - 1] : nil
        }
    }


    private func fetchSongChordInstances() {
        let request: NSFetchRequest<SongChordInstance> = SongChordInstance.fetchRequest()
        request.predicate = NSPredicate(format: "song == %@", song)
        do {
            songChordInstances = try context.fetch(request).sorted { $0.start_time < $1.start_time }
            updateChords()  // Update chords after fetching
        } catch {
            print("Error fetching song chord instances: \(error)")
        }
    }


    private func calculateTotalDuration() {
        totalDuration = songChordInstances.last?.end_time ?? 0.0
    }
}
