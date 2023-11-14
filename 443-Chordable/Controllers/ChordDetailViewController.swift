//
//  ChordDetailViewController.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 10/31/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import Foundation
import SwiftUI
import AVFoundation

enum ChordDetailError: Error, Equatable {
  case fileNotFound(chordName: String)
  case chordFileError
}

class ChordDetailViewController: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  @Published var status: AudioStatus = .stopped
  @Published var isRecordingActive: Bool = false
  @Published var hasMicAccess = false
  @Published var displayNotification = false
  @Published var countdown = 3
  @Published var isCountingDown = false
  @Published var duration = 5
  @Published var countdownTimer: Timer?
  @Published var durationTimer: Timer?
  @Published var isSuccess = false
  @Published var showResultView = false

  func viewDidLoad() {
    // configure audio permissions
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
      try session.setActive(true)
    } catch {
      print("AVAudioSession configuration error: \(error.localizedDescription)")
    }
  }
  
  var audioPlayer: AVAudioPlayer?
  var audioRecorder: AVAudioRecorder?
  var timer: Timer?
  let chord: Chord
  
  init(chord: Chord) {
    self.chord = chord
    super.init()
  }
  
  // MARK: - Playing Audio -
  
  // playing audio
  func playChord(chordName: String) throws {
    // change audio file path for each chord
    guard let asset  = NSDataAsset(name: "\(chordName)_audio") else {
      throw ChordDetailError.fileNotFound(chordName: chordName)
    }
    do {
      audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint:"wav")
      audioPlayer?.delegate = self
      status = .playing
      audioPlayer?.play()
      status = .stopped
    } catch ChordDetailError.chordFileError {
      print("Error playing chord file")
      throw ChordDetailError.chordFileError
    }
  }
  
  func completeChord() {
    
  }
  
  // MARK: - Recording Audio -
  
  // save recorded audio to temporary directory
  var urlForMemo: URL {
    let fileManager = FileManager.default
    let tempDir = fileManager.temporaryDirectory
    let filePath = "TempMemo.wav"
    return tempDir.appendingPathComponent(filePath)
  }
  
  // recording function
  func setupRecorder() {
    // set up recording setting
    let recordSettings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatLinearPCM),
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]
    
    // creating recorder
    do {
      audioRecorder = try AVAudioRecorder(url: urlForMemo, settings: recordSettings)
      audioRecorder?.delegate = self
      
      if let recorder = audioRecorder, !recorder.prepareToRecord() {
        print("Failed to prepare to record.")
      }
    } catch {
      print("Error creating audio recording: \(error.localizedDescription)")
    }
  }
  
  func startRecording(for duration: TimeInterval, completion: @escaping (String) -> Void) {
      setupRecorder()
      
      // Check if the recorder is prepared to record and start recording, otherwise handle the error
      if let recorder = audioRecorder, recorder.prepareToRecord() {
          recorder.record()
          status = .recording
          
          // Start a timer for the duration of the recording
          timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
              self?.stopRecording(completion: completion)
          }
      } else {
          print("Recorder not ready or setup failed.")
          status = .stopped
          completion("Error") // Indicate an error or a specific string to notify of the setup failure
      }
  }
  
  func stopRecording(completion: @escaping (String) -> Void) {
      audioRecorder?.stop()
      status = .stopped
      
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { // We can adjust the delay as needed
          self.isRecordingActive = false
          // Simulate fetching and processing the response
          let mockChordResponse: ChordResponse = Bundle.main.decode(ChordResponse.self, from: "mock_chord_output.json")
          completion(mockChordResponse.chord)
      }
  }
  
  // MARK: - Start Countdown and Duration Timer -
  
  // 3 second countdown
  func startCountdown() {
      countdownTimer?.invalidate()
      isCountingDown = true
      countdown = 3 // Start from 3 seconds
      countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          if self.countdown > 1 {
              self.countdown -= 1
          } else {
              self.isCountingDown = false
              self.countdownTimer?.invalidate()
              self.startDuration() // Call startDuration to manage recording time
          }
      }
  }
  
  // 5 seconds recording
  func startDuration() {
    durationTimer?.invalidate()
    isRecordingActive = true
    duration = 5
    durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      if self.duration > 1 {
        self.duration -= 1
      } else {
        // stop recording at the end of 5 seconds
        self.durationTimer?.invalidate()
        self.stopRecording() { predictedChord in
          DispatchQueue.main.async {
            let success = predictedChord == self.chord.chord_name
            if success {
              self.chord.completed = true
              // Save the context here
              if let context = self.chord.managedObjectContext {
                do {
                  try context.save()
                } catch {
                  // Handle the error
                  print("Failed to save context: \(error)")
                }
              }
            }
            self.isSuccess = success
            self.showResultView = true
          }
        }
      }
    }
    startRecording(for: 5) { predictedChord in
      // ... handle completion
    }
  }
  
  // MARK: - Microphone Permissions -
  func requestMicrophoneAccess() {
      AVAudioSession.sharedInstance().requestRecordPermission { granted in
          DispatchQueue.main.async {
              self.hasMicAccess = granted
              if granted {
                  // Initiate the countdown only if the microphone access is granted and if it is not already counting down
                  if !self.isCountingDown {
                      self.startCountdown()
                  }
              } else {
                  // Alert the user that microphone access is required
                  self.displayNotification = true
              }
          }
      }
  }
}

extension ChordDetailViewController {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    status = .stopped
  }
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    if flag {
      DispatchQueue.main.async {
        self.status = .stopped
      }
    }
  }
}
