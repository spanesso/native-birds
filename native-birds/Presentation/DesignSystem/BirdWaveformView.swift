//
//  BirdWaveformView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

private struct BirdWaveformView: View {

    let audioState: BirdAudioUIState
    let waveform: [CGFloat]

    var body: some View {
        Group {
            switch audioState {

            case .ready, .playing, .paused:
                if waveform.isEmpty {
                    WaveformBarsView(
                        samples: Array(repeating: 0.35, count: 48)
                    )
                    .redacted(reason: .placeholder)
                } else {
                    WaveformBarsView(samples: waveform)
                }

            case .downloading:
                ProgressView()

            default:
                EmptyView()
            }
        }
        .frame(height: BirdSpacing.loadinViewSpacingHeight / 3)
        .padding(.horizontal, BirdSpacing.screenHorizontal)
    }
}
