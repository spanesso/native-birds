//
//  BirdFlightView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 11/01/26.
//

import SwiftUI
import SpriteKit

struct BirdFlightView: View {

    let spriteSheetName: String

    var body: some View {
        SpriteView(
            scene: BirdFlightScene(
                size: CGSize(width: 300, height: 200),
                spriteSheetName: spriteSheetName
            ),
            options: [.allowsTransparency]
        )
        .frame(width: 300, height: 300)
        .background(Color.clear)
    }
}

#Preview("Bird Flight Animation") {
    ZStack {
        Color.black
        BirdFlightView(spriteSheetName: "sprite_animation")
    }
}

