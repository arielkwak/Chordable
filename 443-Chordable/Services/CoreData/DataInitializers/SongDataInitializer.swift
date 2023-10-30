
//
//  SongDataInitializer.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import CoreData

class SongDataInitializer {
  
    func initializeSongData(into context: NSManagedObjectContext) {
        guard let intermediatePath = Bundle.main.resourceURL?.appendingPathComponent("Chord-Annotations-master copy") else {
            print("Failed to find intermediate path")
            return
        }

        let basePath = intermediatePath.appendingPathComponent("uspopLabels")

        do {
            let artists = try FileManager.default.contentsOfDirectory(at: basePath, includingPropertiesForKeys: nil)

            for artistURL in artists {
                let albums = try FileManager.default.contentsOfDirectory(at: artistURL, includingPropertiesForKeys: nil)
                
                for albumURL in albums {
                    let songs = try FileManager.default.contentsOfDirectory(at: albumURL, includingPropertiesForKeys: nil, options: [])
                    
                    for songURL in songs {
                        if songURL.pathExtension == "lab" {
                            let songTitleWithID = songURL.deletingPathExtension().lastPathComponent
                            let songTitleComponents = songTitleWithID.split(separator: "-")
                            guard songTitleComponents.count >= 2 else { continue }  // Safeguard against missing '-'
                            
                            let songTitle = String(songTitleComponents[1])
                            
                            let song = Song(context: context)
                            song.song_id = UUID()
                            song.title = songTitle
                            song.artist = artistURL.lastPathComponent
                            song.album = albumURL.lastPathComponent
                            song.audio_file = "\(songTitle).wav"

                            if let fileContents = try? String(contentsOf: songURL), !fileContents.isEmpty {
                                let lines = fileContents.split(separator: "\n")
                                
                                for line in lines {
                                    let components = line.split(separator: "\t")
                                    
                                    if components.count == 3,
                                       let startTime = Float(components[0]),
                                       let endTime = Float(components[1]) {
                                        let chordName = String(components[2])
                                        
                                        let songChordInstance = SongChordInstance(context: context)
                                        songChordInstance.song_chord_instance_id = UUID()
                                        songChordInstance.song = song
                                        songChordInstance.start_time = startTime
                                        songChordInstance.end_time = endTime
                                        songChordInstance.chord_name = chordName
                                    }
                                }
                            }
                        }
                    }
                }
            }

            try context.save()
        } catch {
            print("Failed to save context or read directory: \(error)")
        }
    }
}
