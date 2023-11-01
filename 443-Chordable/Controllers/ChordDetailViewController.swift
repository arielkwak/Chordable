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
  
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  
  // MARK: - Playing Audio -
  
  // playing audio
  func playChord() {
    print("playing")
    // change audio file path for each chord
    guard let path = Bundle.main.path(forResource: "sample-audio-test", ofType: "wav") else {
      print("File not found")
      return
    }
    let url = URL(fileURLWithPath: path)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.delegate = self
      status = .playing
      audioPlayer?.play()
      status = .stopped
    } catch {
      print("Error playing chord file")
    }
  }
  
  
  // MARK: - Recording Audio -
  
  // save recorded audio to temporary directory
  var urlForMemo: URL {
    let fileManager = FileManager.default
    let tempDir = fileManager.temporaryDirectory
    let filePath = "TempMemo.caf"
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
    } catch {
      print("Error creating audioRecording")
    }
  }
  
  // begin recording for 5 seconds
  func record(forDuration duration: TimeInterval) {
    audioRecorder?.record(forDuration: duration)
    status = .recording
  }
  
  // stop recording
  func stopRecording() {
    audioRecorder?.stop()
    status = .stopped
  }
}

extension ChordDetailViewController {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    status = .stopped
  }
}