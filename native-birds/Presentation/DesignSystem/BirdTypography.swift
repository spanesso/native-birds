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
        case .listTitle:
            return .system(size: 22, weight: .bold)
        case .listSubtitle:
            return .system(size: 16, weight: .regular)
        // existentes…
        default:
            return .system(size: 16)
        }
    }

    static func color(for style: BirdLabelStyle) -> Color {
        switch style {
        case .listTitle:
            return BirdTheme.deepBlack
        case .listSubtitle:
            return BirdTheme.primaryGreen
        default:
            return .primary
        }
    }
 

    static func alignment(for style: BirdLabelStyle) -> Alignment {
        switch style {
            case .title, .subtitle:
                return .center
            case .body, .caption:
                return .leading
            case .listTitle, .listSubtitle:
                return .leading
        }
    }
}


