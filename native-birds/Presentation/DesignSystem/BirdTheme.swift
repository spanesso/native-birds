//
//  BirdTheme.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

enum BirdTheme {
    static let primaryGreen = Color(hex: "#2D5A27")
    static let accentYellow = Color(hex: "#FFD700")
    static let electricBlue = Color(hex: "#0077B6")
    static let deepBlack = Color(hex: "#121212")
    static let surfaceWhite = Color(hex: "#F8F9FA")
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0

        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }
}
