//
//  WaveformBarsView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//


import SwiftUI

struct WaveformBarsView: View {

    let samples: [CGFloat]

    var body: some View {
        GeometryReader { geo in
            let count = max(samples.count, 1)
            let spacing: CGFloat = 3
            let barWidth = max((geo.size.width - (CGFloat(count - 1) * spacing)) / CGFloat(count), 2)

            HStack(alignment: .center, spacing: spacing) {
                ForEach(samples.indices, id: \.self) { i in
                    
                    let amp = min(
                        max(samples[i], 0.05), 1.0
                    )
                    
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(BirdTheme.electricBlue)
                    
                        .frame(
                            width: barWidth,
                            height: geo.size.height * amp
                        )
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center)
        }
        .frame(height: 64)
    }
}


#Preview("Waveform Variations") {
    VStack(spacing: 40) {
        WaveformBarsView(samples: [0.2, 0.5, 0.8, 0.4, 0.9, 0.3])
            .padding()
            .background(Color.black.opacity(0.05))
        
        WaveformBarsView(samples: (0...40).map { _ in CGFloat.random(in: 0.1...1.0) })
            .padding()
            .background(BirdTheme.deepBlack)
    }
}
