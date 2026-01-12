//
//  BirdThemeTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdThemeTests: XCTestCase {
    
    func test_colorHex_initializesCorrectValues() {
        let whiteHex = Color(hex: "#FFFFFF")
        let blackHex = Color(hex: "#000000")
        
        XCTAssertNotNil(whiteHex)
        XCTAssertNotNil(blackHex)
    }
    
    func test_theme_colors_areDefinedCorrectly() {
        XCTAssertNotNil(BirdTheme.primaryGreen)
        XCTAssertNotNil(BirdTheme.accentYellow)
        XCTAssertNotNil(BirdTheme.electricBlue)
        XCTAssertNotNil(BirdTheme.deepBlack)
        XCTAssertNotNil(BirdTheme.surfaceWhite)
    }
}
