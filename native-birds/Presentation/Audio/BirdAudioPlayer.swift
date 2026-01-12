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
final class BirdAudioPlayer: ObservableObject, BirdAudioPlayerProtocol {
    
    @Published private(set) var isPlaying: Bool = false
    
    private var player: AVPlayer?
    private var playerItemContext = 0
    private var timeObserver: Any?
    
    var onDidFinishPlaying: (() -> Void)?
    
    func play(url: URL) {
        stop()
        
        let playerItem = AVPlayerItem(url: url)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        if player == nil {
            player = AVPlayer(playerItem: playerItem)
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        isPlaying = false
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func handlePlaybackFinished() {
        isPlaying = false
        player?.seek(to: .zero)
        onDidFinishPlaying?()
    }
    
    @objc private func playerDidFinishPlaying() {
        isPlaying = false
        player?.seek(to: .zero)
        onDidFinishPlaying?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
