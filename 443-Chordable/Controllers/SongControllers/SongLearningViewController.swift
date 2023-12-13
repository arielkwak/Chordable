//
//  SongLearningViewController.swift
//  443-Chordable
//
//  Created by Owen Gometz on 11/19/23.
//

import Foundation
import CoreData
import SpotifyWebAPI
import Combine

class SongLearningViewController: ObservableObject {
    @Published var currentChords: [SongChordInstance?] = [nil, nil, nil, nil] // Current and next 3 chords
    @Published var isPlaying = false
    @Published var progress: Float = 0.0 // For progress bar
    @Published var playAlong = false
    @Published var playRequestCancellable: AnyCancellable? = nil
    @Published var pauseRequestCancellable: AnyCancellable? = nil
  
    @Published var secondsToNextChord: Float?
  
    var isAtStartingPosition: Bool {
        return elapsedTime == 0.0
    }

    private let context: NSManagedObjectContext
    private var timer: Timer?
    private var elapsedTime: Float = 0.0
    private var totalDuration: Float = 0.0
  
    var showAlert: ((AlertItem) -> Void)?
    var song: Song // Make this internal or public
    var spotify: Spotify
    var songChordInstances: [SongChordInstance] = []

    init(context: NSManagedObjectContext, song: Song, spotify: Spotify) {
        self.context = context
        self.song = song
        self.spotify = spotify
        fetchSongChordInstances()
        calculateTotalDuration()
        updateChords()
    }
  
  
    func startPlayPause() {
      // if play along, then play
      if playAlong {
        // if is paused, then play song
        // if is playing, then pause song
        if !isPlaying {
          if progress > 0 {
            resumeSong()
          } else {
            playSong()
          }
        } else {
          pauseSong()
        }
        // play/pause chords
        playPauseToggled()
      } else {
        playPauseToggled()
      }
    }
    
  func playSong() {
          let alertTitle = "Couldn't Play \(song.title ?? "Song")"
          guard let trackURI = song.uri else {
              handleAlert(title: alertTitle, message: "Missing URI")
              return
          }
          let playbackRequest = PlaybackRequest(trackURI)
          
          playRequestCancellable = spotify.api.getAvailableDeviceThenPlay(playbackRequest)
              .receive(on: RunLoop.main)
              .sink(receiveCompletion: { [weak self] completion in
                  if case .failure(let error) = completion {
                      self?.handleAlert(title: alertTitle, message: error.localizedDescription)
                  }
              }, receiveValue: { _ in })
      }

      // Pause Song
      func pauseSong() {
          let alertTitle = "Couldn't Pause \(song.title ?? "Song")"
          pauseRequestCancellable = spotify.api.pausePlayback()
              .receive(on: RunLoop.main)
              .sink(receiveCompletion: { [weak self] completion in
                  if case .failure(let error) = completion {
                      self?.handleAlert(title: alertTitle, message: error.localizedDescription)
                  }
              }, receiveValue: { _ in })
      }

      // Resume Song
      func resumeSong() {
          let alertTitle = "Couldn't Resume \(song.title ?? "Song")"
          playRequestCancellable = spotify.api.resumePlayback()
              .receive(on: RunLoop.main)
              .sink(receiveCompletion: { [weak self] completion in
                  if case .failure(let error) = completion {
                      self?.handleAlert(title: alertTitle, message: error.localizedDescription)
                  }
              }, receiveValue: { _ in })
      }


    func playPauseToggled() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }
  
    func restartSong() {
        elapsedTime = 0.0
        progress = 0.0
        updateChords()
        isPlaying = false
        // Optionally reset Spotify playback here if needed
    }

    private func handleAlert(title: String, message: String) {
        let alert = AlertItem(title: title, message: message)
        showAlert?(alert)
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
        let currentChord = songChordInstances.first { instance in
            elapsedTime >= instance.start_time && elapsedTime < instance.end_time
        }

        currentChords[0] = currentChord

        let searchTime = currentChord?.end_time ?? elapsedTime

        let upcomingChords = songChordInstances.filter { $0.start_time >= searchTime }
        for i in 1...3 {
            currentChords[i] = (i - 1) < upcomingChords.count ? upcomingChords[i - 1] : nil
        }

        if elapsedTime >= totalDuration {
            stopTimer()
            isPlaying = false
            progress = 1.0
            restartSong()
        }

        if let nextChord = upcomingChords.first {
            secondsToNextChord = nextChord.start_time - elapsedTime
        } else {
            secondsToNextChord = nil
        }
        let chordNames = currentChords.map { $0?.chord?.chord_name ?? "No Chord" }
    }



    private func fetchSongChordInstances() {
        let request: NSFetchRequest<SongChordInstance> = SongChordInstance.fetchRequest()
        request.predicate = NSPredicate(format: "song == %@", song)
        do {
            songChordInstances = try context.fetch(request).sorted { $0.start_time < $1.start_time }
        } catch {
            print("Error fetching song chord instances: \(error)")
        }
    }


    private func calculateTotalDuration() {
        totalDuration = songChordInstances.last?.end_time ?? 0.0
        print(totalDuration)
    }
}
