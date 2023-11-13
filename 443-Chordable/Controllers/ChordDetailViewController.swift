//
//  ChordDetailViewController.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 10/31/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import Foundation
import SwiftUI
import AVFoundation

class ChordDetailViewController: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  @Published var status: AudioStatus = .stopped
  @Published var isRecordingActive: Bool = false
  
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
  
  // MARK: - Playing Audio -
  
  // playing audio
  func playChord(chordName: String) {
    // change audio file path for each chord
    guard let asset  = NSDataAsset(name: "\(chordName)_audio") else {
      print("File not found for chord: \(chordName)")
      return
    }
    do {
      audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint:"wav")
      audioPlayer?.delegate = self
      status = .playing
      audioPlayer?.play()
      status = .stopped
    } catch {
      print("Error playing chord file")
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
