//
//  BirdHeroImage.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI
import Foundation

private struct BirdHeroImage: View {

    let url: URL?
    let cache: BirdImageCacheProtocol

    var body: some View {
        BirdRemoteImage(
            url: url,
            cache: cache
        )
        .scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
