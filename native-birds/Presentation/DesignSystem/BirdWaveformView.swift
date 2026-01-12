//
//  BirdWaveformView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

struct BirdWaveformView: View {
    let audioState: BirdAudioUIState
    let waveform: [CGFloat]
    
    private let strictHeight: CGFloat = 64
    
    var body: some View {
            ZStack {
                switch audioState {
                case .ready, .playing, .paused:
                    if waveform.isEmpty {
                        WaveformBarsView(samples: Array(repeating: 0.1, count: 40))
                            .opacity(0.1)
                    } else {
                        WaveformBarsView(samples: waveform)
                    }
                
                default:
                    Color.clear
                }
            }
            .frame(height: strictHeight)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, BirdSpacing.screenHorizontal)
        }
}

#Preview("Waveform") {
    VStack(spacing: 40) {
        VStack(alignment: .leading) {
            BirdWaveformView(
                audioState: .downloading(progress: 0.4),
                waveform: []
            )
        }
        
        VStack(alignment: .leading) {
            BirdWaveformView(
                audioState: .ready(localFileURL: URL(fileURLWithPath: "")),
                waveform: [0.2, 0.5, 0.8, 0.4, 0.9, 0.3, 0.7, 0.2, 0.5, 0.8]
            )
        }
        
        VStack(alignment: .leading) {
            BirdWaveformView(
                audioState: .ready(localFileURL: URL(fileURLWithPath: "")),
                waveform: []
            )
        }
    }
    .padding()
}
