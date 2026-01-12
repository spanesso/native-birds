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
    
    func play(url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.isPlaying = false
            self?.player?.seek(to: .zero)
        }
        
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
    }
    
    @objc private func playerDidFinishPlaying() {
        Task { @MainActor in
            self.isPlaying = false
            self.player?.seek(to: .zero)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
