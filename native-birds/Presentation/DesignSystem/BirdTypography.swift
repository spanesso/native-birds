//
//  BirdTypography.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

enum BirdTypography {

    static func font(for style: BirdLabelStyle) -> Font {
        switch style {
        case .title:
            return .system(size: 52, weight: .heavy)

        case .subtitle:
            return .system(size: 20, weight: .regular)

        case .body:
            return .system(size: 16, weight: .regular)

        case .caption:
            return .system(size: 13, weight: .regular)
        }
    }

    static func color(for style: BirdLabelStyle) -> Color {
        switch style {
        case .title:
            return .white

        case .subtitle:
            return .white.opacity(0.85)

        case .body:
            return BirdTheme.deepBlack

        case .caption:
            return BirdTheme.deepBlack.opacity(0.7)
        }
    }

    static func alignment(for style: BirdLabelStyle) -> Alignment {
        switch style {
        case .title, .subtitle:
            return .center
        case .body, .caption:
            return .leading
        }
    }
}


