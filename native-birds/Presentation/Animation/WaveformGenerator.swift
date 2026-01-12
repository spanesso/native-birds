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

            let strideSize = max(frameLength / samples, 1)

            var result: [CGFloat] = []
            result.reserveCapacity(samples)

            var maxAmp: Float = 0

            var amps: [Float] = []
            amps.reserveCapacity(samples)

            var idx = 0
            while idx < frameLength && amps.count < samples {
                let end = min(idx + strideSize, frameLength)
                var sum: Float = 0
                var count: Float = 0
                for i in idx..<end {
                    let v = fabsf(channelData[i])
                    sum += v
                    count += 1
                }
                let avg = count > 0 ? sum / count : 0
                amps.append(avg)
                maxAmp = max(maxAmp, avg)
                idx += strideSize
            }

            let denom = maxAmp > 0 ? maxAmp : 1
            for a in amps {
                result.append(CGFloat(a / denom))
            }

            return result
        }.value
    }
}
