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

final class PreviewImageCache: BirdImageCacheProtocol, @unchecked Sendable {
    func image(for url: URL) async -> UIImage? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return UIImage(systemName: "bird.fill")
    }

    func store(_ image: UIImage, for url: URL) async {
    }
}

#Preview("Success") {
    BirdHeroImage(
        url: URL(string: "https://example.com/bird.jpg"),
        cache: PreviewImageCache()
    )
    .frame(height: 300)
}

#Preview("Error") {
    BirdHeroImage(
        url: nil,
        cache: PreviewImageCache()
    )
    .frame(height: 300)
}

