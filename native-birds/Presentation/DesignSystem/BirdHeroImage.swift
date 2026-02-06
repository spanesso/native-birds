//
//  BirdHeroImage.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI
import Foundation

struct BirdHeroImage: View {
    let url: URL?
    let cache: BirdImageCacheProtocol

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BirdRemoteImage(
                    url: url,
                    hugeImage: true,
                    cache: cache
                )
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .contentShape(Rectangle())
                .clipped()
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}
