//
//  BirdDetailView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//
import SwiftUI

struct BirdDetailView: View {
    let bird: Bird
    let imageCache: BirdImageCacheProtocol
    let onBack: () -> Void
    
    @StateObject var viewModel: BirdDetailViewModel
    @StateObject private var audioPlayer = BirdAudioPlayer()
    
    var body: some View {
        BirdDetailContent(
            delegate: self,
            bird: bird,
            imageCache: imageCache,
            audioState: viewModel.audioState,
            waveform: viewModel.waveform,
            audioPlayer: audioPlayer
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

extension BirdDetailView: BirdDetailContentViewDelegate {
    func onBackAction() {
        onBack()
    }
    
    func onPlayToggle() {
        viewModel.togglePlay(using: audioPlayer)
    }
}
