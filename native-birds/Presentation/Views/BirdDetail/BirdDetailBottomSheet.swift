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
        VStack(spacing: BirdSpacing.sectionVertical) {
            BottomSheetGrabber()

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

            HStack(spacing: BirdSpacing.buttonVertical) {
                BirdPlayButton(
                    audioState: viewModel.audioState,
                    action: {
                        viewModel.togglePlay(using: audioPlayer)
                    }
                )
            }
            .padding(.top, BirdSpacing.buttonVertical)

            BirdWikipediaSection(url: bird.wikipediaURL)
        }
        .padding(.bottom, BirdSpacing.buttonVertical + 20)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .background(
            RoundedRectangle(
                cornerRadius: BirdSpacing.listItemCornerRadius,
                style: .continuous
            )
            .fill(BirdTheme.surfaceWhite)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -10)
        )
    }
}
