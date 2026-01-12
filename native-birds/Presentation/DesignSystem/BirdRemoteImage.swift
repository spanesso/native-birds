//
//  BirdRemoteImage.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI
import UIKit

struct BirdRemoteImage: View {

    let url: URL?
    let cache: BirdImageCacheProtocol

    @State private var uiImage: UIImage?

    var body: some View {
        ZStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                
                BirdFlightView(
                    spriteSheetName: "sprite_animation"
                )
                .frame(
                    width: BirdSpacing.loadinViewSpacingWidth,
                    height: BirdSpacing.loadinViewSpacingHeight
                )
            }
        }
        .clipped()
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else { return }

        if let cached = await cache.image(for: url) {
            self.uiImage = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let img = UIImage(data: data) {
                self.uiImage = img
                await cache.store(img, for: url)
            }
        } catch {}
    }
}


#Preview("Remote Image States") {
    VStack {
        BirdRemoteImage(
            url: nil,
            cache: MockImageCache()
        )
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
        Text("Placeholder State").font(.caption)
    }
}

