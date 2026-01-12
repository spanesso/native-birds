//
//  WaveformGenerator.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

 

import Foundation
import AVFoundation

enum WaveformGenerator {

    static func generate(from localAudioURL: URL, samples: Int = 60) async throws -> [CGFloat] {
        try await Task.detached(priority: .userInitiated) {
            let file = try AVAudioFile(forReading: localAudioURL)
            guard let buffer = AVAudioPCMBuffer(
                pcmFormat: file.processingFormat,
                frameCapacity: AVAudioFrameCount(file.length)
            ) else {
                return []
            }

            try file.read(into: buffer)

            guard let channelData = buffer.floatChannelData?[0] else { return [] }
            let frameLength = Int(buffer.frameLength)
            if frameLength <= 0 { return [] }

           

            return result
        }.value
    }
}
