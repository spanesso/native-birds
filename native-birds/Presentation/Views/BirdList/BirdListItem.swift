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

            VStack(alignment: .leading, spacing: 6) {
                Text(bird.englishCommonName ?? bird.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(BirdTheme.deepBlack)

                Text(bird.name)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(BirdTheme.primaryGreen)
            }

            Spacer()

            HStack(spacing: 12) {
                Circle()
                    .fill(BirdTheme.accentYellow)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "location.fill")
                            .foregroundStyle(.black.opacity(0.75))
                    )

                Circle()
                    .fill(BirdTheme.electricBlue)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "play.fill")
                            .foregroundStyle(.white)
                    )
            }
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

