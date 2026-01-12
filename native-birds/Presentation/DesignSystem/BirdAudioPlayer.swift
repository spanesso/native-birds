//
//  BirdAudioPlayer.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

 

import Foundation
import AVFoundation
internal import Combine

@MainActor
final class BirdAudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published private(set) var isPlaying: Bool = false

    private var player: AVAudioPlayer?

    func load(localURL: URL) throws {
        player = try AVAudioPlayer(contentsOf: localURL)
        player?.delegate = self
        player?.prepareToPlay()
        isPlaying = false
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
    }

    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        isPlaying = false
    }
}
