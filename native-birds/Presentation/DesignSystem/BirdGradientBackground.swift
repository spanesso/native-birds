//
//  BirdGradientBackground.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 10/01/26.
//

import SwiftUI

struct BirdGradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                BirdTheme.primaryGreen,
                BirdTheme.electricBlue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
