//
//  BirdDetailContent.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

struct BirdDetailContent: View {
    let bird: Bird
    let imageCache: BirdImageCacheProtocol
    let audioState: BirdAudioUIState
    let waveform: [CGFloat]
    let audioPlayer: BirdAudioPlayer
    
    let onBack: () -> Void
    let onPlayToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            BirdHeroImage(url: bird.defaultPhotoMediumUrl, cache: imageCache)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(0)
            
            backgroundGradient
            
            BirdBackButton(action: onBack)
                .zIndex(2)
            
            VStack {
                Spacer()
                BirdDetailContentSheet(
                    birdName: bird.preferredCommonName ?? bird.name,
                    birdScientificName: bird.name,
                    wikipediaURL: bird.wikipediaURL,
                    audioState: audioState,
                    waveform: waveform,
                    onPlayToggle: onPlayToggle
                )
            }
            .zIndex(3)
        }
    }
    
    @ViewBuilder
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.black.opacity(0.5), .clear],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 150)
        .ignoresSafeArea()
        .zIndex(1)
    }
}

#Preview("Bird Detail - Loading Audio") {
    BirdDetailContent(
        bird: .preview(),
        imageCache: MockBirdImageCache(),
        audioState: .downloading(progress: 0.5),
        waveform: [],
        audioPlayer: BirdAudioPlayer(),
        onBack: {},
        onPlayToggle: {}
    )
}

#Preview("Bird Detail - Ready State") {
    BirdDetailContent(
        bird: .preview(english: "Great Kiskadee", scientific: "Pitangus sulphuratus"),
        imageCache: MockBirdImageCache(),
        audioState: .ready(localFileURL: URL(fileURLWithPath: "")),
        waveform: [0.2, 0.8, 0.4, 0.9, 0.5, 0.7, 0.3],
        audioPlayer: BirdAudioPlayer(),
        onBack: {},
        onPlayToggle: {}
    )
}

#Preview("Bird Detail - Playing State") {
    BirdDetailContent(
        bird: .preview(),
        imageCache: MockBirdImageCache(),
        audioState: .playing(localFileURL: URL(fileURLWithPath: "")),
        waveform: [0.5, 0.5, 0.5, 0.5, 0.5],
        audioPlayer: BirdAudioPlayer(),
        onBack: {},
        onPlayToggle: {}
    )
}
