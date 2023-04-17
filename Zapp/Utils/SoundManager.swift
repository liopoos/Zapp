//
//  SoundManager.swift
//  Zapp
//
//  Created by hades on 2023/4/3.
//

import AVFoundation
import AppKit

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    private func playSoundEffectByFile(filename: String, extension ext: String = "wav") {
        guard let soundURL = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("Failed to find sound file: \(filename).\(ext)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func success() {
        playSoundEffectByFile(filename: "sound_success")
    }
    
    func error() {
        NSSound.tink?.play()
    }
}
