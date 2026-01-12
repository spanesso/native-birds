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

    let onBack: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            BirdRemoteImage(
                url: bird.defaultPhotoMediumUrl ?? bird.defaultPhotoUrl,
                cache: imageCache
            )
            .scaledToFill()
            .ignoresSafeArea()

            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.onAppear() }
    }



}
