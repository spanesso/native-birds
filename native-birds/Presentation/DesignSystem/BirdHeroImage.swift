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
        ZStack {
            BirdRemoteImage(url: url, cache: cache)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: 30)
                .opacity(0.7)
                .overlay(Color.black.opacity(0.3))

            BirdRemoteImage(url: url, cache: cache)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 10)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}
