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
        BirdRemoteImage(url: url, cache: cache)
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
    }
}
