//
//  BirdDetailBottomSheet.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

private struct BirdDetailBottomSheet: View {
    
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
                         audioState: audioState,
                         action: onAction
                     )
                 }
                 .padding(.top, BirdSpacing.buttonVertical)
            
            BirdWikipediaSection(url: bird.wikipediaURL)
            
            Spacer(minLength: BirdSpacing.contentVertical)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: BirdSpacing.listItemCornerRadius,
                style: .continuous
            )
            .fill(BirdTheme.surfaceWhite)
            .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private func handlePlayAction() {
        switch viewModel.audioState {
            
        case .ready(let url):
            try? audioPlayer.load(localURL: url)
            audioPlayer.play()
            viewModel.audioState = .playing(localFileURL: url)
            
        case .playing(let url):
            audioPlayer.pause()
            viewModel.audioState = .paused(localFileURL: url)
            
        case .paused(let url):
            audioPlayer.play()
            viewModel.audioState = .playing(localFileURL: url)
            
        default:
            break
        }
    }
}
