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
    var hugeImage: Bool = false
    let cache: BirdImageCacheProtocol
    
    @State private var uiImage: UIImage?
    
    var body: some View {
        ZStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .overlay {
                        if hugeImage {
                            BirdFlightView(
                                spriteSheetName: "sprite_animation"
                            )
                        } else {
                            ProgressView()
                                .tint(.white.opacity(0.7))
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: url) { await load() }
    }
    
    private func load() async {
        guard let url = url else { return }
        
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
        } catch {  }
    }
}


#Preview("Remote Image") {
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

