//
//  BirdDetailContentSheet.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

struct BirdDetailContentSheet: View {
    let birdName: String
    let birdScientificName: String
    let wikipediaURL: URL?
    let audioState: BirdAudioUIState
    let waveform: [CGFloat]
    
    let onPlayToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundSurface
            
            VStack(spacing: 0) {
                BottomSheetGrabber()
                    .padding(.bottom, BirdSpacing.sectionVertical)
                
                headerSection
                
                BirdWaveformView(
                    audioState: audioState,
                    waveform: waveform
                )
                .padding(.vertical, BirdSpacing.sectionVertical)
                
                BirdPlayButton(
                    audioState: audioState,
                    action: onPlayToggle
                )
                .padding(.bottom, BirdSpacing.sectionVertical)
                
                BirdWikipediaSection(url: wikipediaURL)
                    .padding(.bottom, 12)
            }
            .padding(.horizontal, BirdSpacing.screenHorizontal)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: BirdSpacing.listItemTextSpacing) {
            BirdLabel(
                text: birdName,
                style: .listTitle
            ).multilineTextAlignment(.center)
            
            BirdLabel(
                text: birdScientificName,
                style: .listSubtitle
            ).multilineTextAlignment(.center)
        
        }
    }
    
    private var backgroundSurface: some View {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
            .fill(BirdTheme.surfaceWhite)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -10)
            .ignoresSafeArea(edges: .bottom)
    }
}

#Preview("State: Idle / Loading Audio") {
    BirdDetailContentSheet(
        birdName: "Western Gull",
        birdScientificName: "Larus occidentalis",
        wikipediaURL: nil,
        audioState: .idle,
        waveform: [],
        onPlayToggle: {}
    )
    .background(Color.gray.opacity(0.3))
}

#Preview("State: Downloading (40%)") {
    BirdDetailContentSheet(
        birdName: "Western Gull",
        birdScientificName: "Larus occidentalis",
        wikipediaURL: nil,
        audioState: .downloading(progress: 0.4),
        waveform: [],
        onPlayToggle: {}
    )
}

#Preview("State: Ready to Play") {
    BirdDetailContentSheet(
        birdName: "Western Gull",
        birdScientificName: "Larus occidentalis",
        wikipediaURL: nil,
        audioState: .ready(localFileURL: URL(fileURLWithPath: "")),
        waveform: [0.1, 0.5, 0.8, 0.3, 0.9, 0.4, 0.7],
        onPlayToggle: {}
    )
}

#Preview("State: Playing") {
    BirdDetailContentSheet(
        birdName: "Western Gull",
        birdScientificName: "Larus occidentalis",
        wikipediaURL: nil,
        audioState: .playing(localFileURL: URL(fileURLWithPath: "")),
        waveform: [0.8, 0.9, 0.7, 0.9, 0.8, 1.0],
        onPlayToggle: {}
    )
}

#Preview("State: Error") {
    BirdDetailContentSheet(
        birdName: "Western Gull",
        birdScientificName: "Larus occidentalis",
        wikipediaURL: nil,
        audioState: .error("No internet connection"),
        waveform: [],
        onPlayToggle: {}
    )
}
