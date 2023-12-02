
//
//  SongDataInitializer.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

import CoreData

class SongDataInitializer {
  
    func initializeSongData(into context: NSManagedObjectContext) {
      
        guard let basePath = Bundle.main.resourceURL?.appendingPathComponent("uspopLabels") else {
            print("Failed to find base path")
            return
        }

        do {
            let artists = try FileManager.default.contentsOfDirectory(at: basePath, includingPropertiesForKeys: nil)

            for artist in artists {
                let albums = try FileManager.default.contentsOfDirectory(at: artist, includingPropertiesForKeys: nil)
                
                for album in albums {
                    let songs = try FileManager.default.contentsOfDirectory(at: album, includingPropertiesForKeys: nil, options: [])
                    
                    for song in songs {
                        if song.pathExtension == "lab" {
                            guard let songEntry = createSongRecord(from: song, artist: artist, album: album, into: context) else { continue }
                          
                            createSongChordInstance(from: song, for: songEntry, into: context)
                        }
                    }
                }
            }

            try context.save()
        } catch {
            print("Failed to save context or read directory: \(error)")
        }
    }

    private func createSongRecord(from song: URL, artist: URL, album: URL, into context: NSManagedObjectContext) -> Song? {
        let genreMappings = loadGenreMappings()
        let URIMappings = loadURIMappings()
        let songTitleWithID = song.deletingPathExtension().lastPathComponent
        let songTitleComponents = songTitleWithID.split(separator: "-")
        guard songTitleComponents.count >= 2 else { return nil }
        
        // Replace underscores with spaces in the song title and trim whitespaces
        let songTitle = String(songTitleComponents[1])
                            .replacingOccurrences(of: "_", with: " ")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .capitalized
        
        let songEntry = Song(context: context)
        songEntry.song_id = UUID()
        songEntry.title = songTitle
        songEntry.artist = artist.lastPathComponent
                                .replacingOccurrences(of: "_", with: " ")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
        songEntry.album = album.lastPathComponent
                                .replacingOccurrences(of: "_", with: " ")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
        songEntry.audio_file = "\(songTitle).wav"
        songEntry.genre = genreMappings[songTitle] ?? "Unknown"
        songEntry.uri = URIMappings[songTitle] ?? "Unknown"

        return songEntry
    }



  private func createSongChordInstance(from song: URL, for songEntry: Song, into context: NSManagedObjectContext) {
      if let fileContents = try? String(contentsOf: song), !fileContents.isEmpty {
          let lines = fileContents.split(separator: "\n")
          
          for line in lines {
              let components = line.split(separator: "\t")
              if components.count == 3,
                 let startTime = Float(components[0]),
                 let endTime = Float(components[1]),
                 let chordName = components.count > 2 ? simplifyChordName(String(components[2])) : nil,
                 let chord = findChordObject(chordName: chordName, in: context) {
                  
                  let songChordInstance = SongChordInstance(context: context)
                  songChordInstance.song_chord_instance_id = UUID()
                  songChordInstance.song = songEntry
                  songChordInstance.start_time = startTime
                  songChordInstance.end_time = endTime
                  songChordInstance.chord = chord
              }
          }
      }
  }
  
  
    private func loadGenreMappings() -> [String: String] {
        let genreMappings: [String: String] = Bundle.main.decode([String: String].self, from: "songGenres.json")
        return genreMappings
    }
  
    private func loadURIMappings() -> [String: String] {
        let uriMappings: [String: String] = Bundle.main.decode([String: String].self, from: "spotify.json")
        return uriMappings
      }

  
    func simplifyChordName(_ chordString: String) -> String? {
        let flatToSharp = ["Db": "C#", "Eb": "D#", "Gb": "F#", "Ab": "G#", "Bb": "A#"]
        let parts = chordString.split(separator: ":").map { String($0) }
        guard let chordBase = parts.first else { return nil }

        let simplifiedBase = flatToSharp[chordBase] ?? chordBase
        let isMinor = parts.count > 1 && (parts[1].lowercased().contains("min"))

        return simplifiedBase + (isMinor ? "m" : "")
    }

    func findChordObject(chordName: String, in context: NSManagedObjectContext) -> Chord? {
        // Fetch request to find the chord object that matches the simplified chord name
        let request: NSFetchRequest<Chord> = Chord.fetchRequest()
        request.predicate = NSPredicate(format: "chord_name == %@", chordName)

        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching chord: \(error)")
            return nil
        }
    }

}
