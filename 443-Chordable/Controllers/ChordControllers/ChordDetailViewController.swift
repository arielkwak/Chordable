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
  @Published var hasMicAccess = false
  @Published var displayNotification = false
  @Published var countdown = 3
  @Published var isCountingDown = false
  @Published var duration = 5
  @Published var countdownTimer: Timer?
  @Published var durationTimer: Timer?
  @Published var isSuccess = false
  @Published var showResultView = false

  
  private func setupAudioSession() {
      let session = AVAudioSession.sharedInstance()
      do {
          try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
          try session.setActive(true)
          print("Audio session activated successfully.")
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
      setupAudioSession()
  }
  
  // MARK: - Playing Audio -
  
  func playChord(chordName: String) {
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
  
  
  // MARK: - Recording Audio -
  
  var urlForMemo: URL {
    let fileManager = FileManager.default
    let tempDir = fileManager.temporaryDirectory
    let filePath = "TempMemo.wav"
    return tempDir.appendingPathComponent(filePath)
  }
  
  func setupRecorder() {
    let recordSettings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatLinearPCM),
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: urlForMemo, settings: recordSettings)
      audioRecorder?.delegate = self

      if let recorder = audioRecorder {
          if !recorder.prepareToRecord() {
              print("Failed to prepare to record.")
          } else {
              print("Recorder prepared successfully.")
          }
      } else {
          print("Recorder is nil after initialization.")
      }
    } catch {
        print("Error creating audio recording: \(error.localizedDescription)")
    }
  }
  
  
  func startRecording(for duration: TimeInterval, completion: @escaping (String) -> Void) {
      setupRecorder()
      
      if let recorder = audioRecorder, recorder.prepareToRecord() {
          recorder.record()
          status = .recording
          print("Recording started.")

          timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
              self?.stopRecording(completion: completion)
          }
      } else {
          print("Recorder not ready or setup failed.")
          status = .stopped
          completion("Error")
      }
  }


  func stopRecording(completion: @escaping (String) -> Void) {
      audioRecorder?.stop()
      status = .stopped
      print("Stopped recording. File path: \(urlForMemo.path)")

      if FileManager.default.fileExists(atPath: urlForMemo.path) {
          if let attributes = try? FileManager.default.attributesOfItem(atPath: urlForMemo.path),
             let fileSize = attributes[.size] as? UInt64 {
              print("File size: \(fileSize) bytes.")
              if fileSize > 0 {
                  print("Proceeding with file upload.")
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                      self.isRecordingActive = false
                      
                      self.uploadAudioFile(self.urlForMemo) { predictedChord in
                          DispatchQueue.main.async {
                              completion(predictedChord)
                          }
                      }
                  }
              } else {
                  print("Recorded file is empty.")
                  completion("Error")
              }
          } else {
              print("Unable to retrieve file attributes.")
              completion("Error")
          }
      } else {
          print("Recorded file does not exist.")
          completion("Error")
      }
  }
  
  // MARK: - Start Countdown and Duration Timer -
  
  func startCountdown() {
      countdownTimer?.invalidate()
      isCountingDown = true
      countdown = 3
      countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          if self.countdown > 1 {
              self.countdown -= 1
          } else {
              self.isCountingDown = false
              self.countdownTimer?.invalidate()
              self.startDuration()
          }
      }
  }
  
  func startDuration() {
      durationTimer?.invalidate()
      isRecordingActive = true
      duration = 5

      durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          if self.duration > 0 {
              self.duration -= 1
          } else {
              self.durationTimer?.invalidate()
          }
      }

      startRecording(for: 5) { predictedChord in
          DispatchQueue.main.async {
              let success = predictedChord == self.chord.chord_name
              if success {
                  self.chord.completed = true
                  if let context = self.chord.managedObjectContext {
                      do {
                          try context.save()
                          Song.updateLockedSongs(context: context)
                      } catch {

                          print("Failed to save context: \(error)")
                      }
                  }
              }
              self.isSuccess = success
              self.showResultView = true
              self.isRecordingActive = false
          }
      }
  }

  
  // MARK: - Microphone Permissions -
  func requestMicrophoneAccess() {
      AVAudioSession.sharedInstance().requestRecordPermission { granted in
          DispatchQueue.main.async {
              self.hasMicAccess = granted
              if granted {
                  if !self.isCountingDown {
                      self.startCountdown()
                  }
              } else {
                  self.displayNotification = true
              }
          }
      }
  }

  func uploadAudioFile(_ fileURL: URL, completion: @escaping (String) -> Void) {
      print("Uploading audio file...")
      let url = URL(string: "https://ogometz.pythonanywhere.com/predict")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"

      let boundary = "Boundary-\(UUID().uuidString)"
      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      var data = Data()

      data.append("--\(boundary)\r\n".data(using: .utf8)!)
      data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
      data.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
      data.append(try! Data(contentsOf: fileURL))
      data.append("\r\n".data(using: .utf8)!)
      data.append("--\(boundary)--\r\n".data(using: .utf8)!)

      request.httpBody = data

      URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error during URLSession request: \(error)")
            completion("Error")
            return
        }

        guard let data = data else {
            print("Invalid response data")
            completion("Error")
            return
        }
        
//        // debugging code
//        if let responseString = String(data: data, encoding: .utf8) {
//            print("Raw server response: \(responseString)")
//        }
//        // end of begunning code

        do {
            let chordResponse = try JSONDecoder().decode(ChordResponse.self, from: data)
            completion(chordResponse.chord)  
        } catch {
            print("JSON Decoding Error: \(error)")
            completion("Error")
        }
    }.resume()

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
