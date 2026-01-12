//
//  BirdDetailBottomSheet.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

struct BirdDetailBottomSheet: View {
    let bird: Bird
    @ObservedObject var viewModel: BirdDetailViewModel
    let audioPlayer: BirdAudioPlayer
    
    var body: some View {
        ZStack(alignment: .top) {
            
            RoundedRectangle(cornerRadius: BirdSpacing.listItemCornerRadius, style: .continuous)
                .fill(BirdTheme.surfaceWhite)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -10)
                .ignoresSafeArea(edges: .bottom)
            
            
            VStack(spacing: 0) {
                BottomSheetGrabber()
                    .padding(.bottom, BirdSpacing.sectionVertical)
                
                VStack(spacing: BirdSpacing.listItemTextSpacing) {
                    Text(bird.preferredCommonName ?? bird.name)
                        .font(BirdTypography.font(for: .listTitle))
                        .foregroundColor(BirdTheme.deepBlack)
                        .multilineTextAlignment(.center)
                    
                    Text(bird.name)
                        .font(BirdTypography.font(for: .listSubtitle))
                        .foregroundColor(BirdTheme.primaryGreen)
                }
                .padding(.horizontal, BirdSpacing.screenHorizontal)
                
                BirdWaveformView(
                    audioState: viewModel.audioState,
                    waveform: viewModel.waveform
                )
                .padding(.vertical, BirdSpacing.sectionVertical)
                
                BirdPlayButton(
                    audioState: viewModel.audioState,
                    action: { viewModel.togglePlay(using: audioPlayer) }
                )
                .padding(.bottom, BirdSpacing.sectionVertical)
                
                BirdWikipediaSection(url: bird.wikipediaURL)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .background(
                BirdTheme.surfaceWhite
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -10)
                    .ignoresSafeArea(edges: .bottom)
            )
            .fixedSize(horizontal: false, vertical: true)
            .ignoresSafeArea(edges: .bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview("Bird Detail Bottom Sheet") {
    let mockBird = Bird.preview(
        english: "Western Gull",
        scientific: "Larus occidentalis"
    )
    
    let viewModel = BirdDetailViewModel(
        bird: mockBird,
        remoteConfig: MockRemoteConfig(),
        fetchRecording: MockFetchRecording(),
        audioCache: MockAudioCache(),
        downloader: MockDownloader()
    )
    
    let audioPlayer = BirdAudioPlayer()
    
    ZStack(alignment: .bottom) {
        Color.black.opacity(0.6)
            .ignoresSafeArea()
        
        BirdDetailBottomSheet(
            bird: mockBird,
            viewModel: viewModel,
            audioPlayer: audioPlayer
        )
    }
    .ignoresSafeArea(edges: .bottom)
}


