//
//  BirdsListLoadingView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

struct BirdsListLoadingView: View {

    let text: String

    var body: some View {
        VStack(spacing: BirdSpacing.loadinViewSpacing) {
            BirdFlightView(
                spriteSheetName: "sprite_animation"
            )
            .frame(
                width: BirdSpacing.loadinViewSpacingWidth,
                height: BirdSpacing.loadinViewSpacingHeight
            )

            BirdLabel(
                text: text,
                style: .subtitle
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .multilineTextAlignment(.center)
        .padding(.horizontal, BirdSpacing.screenHorizontal)
    }
}
