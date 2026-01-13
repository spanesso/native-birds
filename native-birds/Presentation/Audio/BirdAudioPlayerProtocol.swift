//
//  BirdAudioPlayerProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import AVFoundation

protocol BirdAudioPlayerProtocol: AnyObject {
    var isPlaying: Bool { get }
    func play(url: URL)
    func pause()
    func stop()
}
