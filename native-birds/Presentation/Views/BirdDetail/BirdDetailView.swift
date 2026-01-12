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

    @StateObject var viewModel: BirdDetailViewModel
    @StateObject private var audioPlayer = BirdAudioPlayer()

    let onBack: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {

            BirdHeroImage(
                url: bird.defaultPhotoMediumUrl,
                cache: imageCache
            )

            BirdDetailBottomSheet(
                bird: bird,
                viewModel: viewModel,
                audioPlayer: audioPlayer
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
}
