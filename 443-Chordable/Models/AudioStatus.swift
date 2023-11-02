//
//  AudioStatus.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 10/31/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import Foundation
import AVFoundation

enum AudioStatus: Int, CustomStringConvertible {
  
  case stopped,
       playing,
       recording
  
  var audioName: String {
    let audioNames = ["Audio:Stopped", "Audio:Playing", "Audio:Recording"]
    return audioNames[rawValue]
  }
  
  var description: String {
    return audioName
  }
}
