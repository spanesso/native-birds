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
        HStack(
            alignment: .center,
            spacing: BirdSpacing.listItemSpacing
        ) {

            BirdRemoteImage(
                url: bird.defaultPhotoUrl,
                hugeImage: false,
                cache: cache
            )
            .frame(
                width: BirdSpacing.listItemImageSize,
                height: BirdSpacing.listItemImageSize
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: BirdSpacing.listItemImageCornerRadius,
                    style: .continuous
                )
            )

            VStack(
                alignment: .leading,
                spacing: BirdSpacing.listItemTextSpacing
            ) {
                BirdLabel(
                    text: bird.name,
                    style: .listTitle
                )
                .lineLimit(2)

                BirdLabel(
                    text: bird.preferredCommonName ?? bird.name,
                    style: .listSubtitle
                )
                .lineLimit(1)
            }

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(BirdSpacing.listItemPadding)
        .background(
            RoundedRectangle(
                cornerRadius: BirdSpacing.listItemCornerRadius,
                style: .continuous
            )
            .fill(.white.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: BirdSpacing.listItemCornerRadius,
                style: .continuous
            )
            .stroke(.white.opacity(0.35), lineWidth: 1)
        )
    }
}

#Preview("BirdListItem – Default") {
    ZStack {
        BirdGradientBackground()

        VStack(spacing: BirdSpacing.sectionVertical) {
            BirdListItem(
                bird: .preview(),
                cache: MockBirdImageCache()
            )

            BirdListItem(
                bird: .preview(
                    english: "Yellow-rumped Cacique With a Very Long Name",
                    scientific: "Cacicus cela cela"
                ),
                cache: MockBirdImageCache()
            )
        }
        .padding(.horizontal, BirdSpacing.screenHorizontal)
    }
}
