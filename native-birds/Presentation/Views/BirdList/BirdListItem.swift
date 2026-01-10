//
//  BirdListItem.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

struct BirdListItem: View {

    let bird: Bird
    let cache: BirdImageCacheProtocol

    var body: some View {
        HStack(spacing: 14) {

            BirdRemoteImage(url: bird.defaultPhotoUrl, cache: cache)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

       
            
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.35), lineWidth: 1)
        )
    }
}
