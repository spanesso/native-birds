//
//  BirdTypographyTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdTypographyTests: XCTestCase {
    
    func test_font_returnsCorrectSizes() {
        XCTAssertEqual(BirdTypography.font(for: .title), .system(size: 52, weight: .heavy))
        XCTAssertEqual(BirdTypography.font(for: .subtitle), .system(size: 20, weight: .regular))
        XCTAssertEqual(BirdTypography.font(for: .caption), .system(size: 13, weight: .regular))
    }
    
    func test_color_returnsExpectedValues() {
        XCTAssertEqual(BirdTypography.color(for: .title), .white)
        XCTAssertEqual(BirdTypography.color(for: .body), BirdTheme.deepBlack)
        XCTAssertEqual(BirdTypography.color(for: .listSubtitle), BirdTheme.primaryGreen)
    }
    
    func test_color_hasCorrectOpacities() {
        let subtitleColor = BirdTypography.color(for: .subtitle)
        let captionColor = BirdTypography.color(for: .caption)
        
        XCTAssertEqual(subtitleColor, .white.opacity(0.85))
        XCTAssertEqual(captionColor, BirdTheme.deepBlack.opacity(0.7))
    }
    
    func test_alignment_mappingsAreCorrect() {
        XCTAssertEqual(BirdTypography.alignment(for: .title), .center)
        XCTAssertEqual(BirdTypography.alignment(for: .subtitle), .center)
        XCTAssertEqual(BirdTypography.alignment(for: .body), .leading)
        XCTAssertEqual(BirdTypography.alignment(for: .listTitle), .leading)
    }
    
    func test_textAlignment_mappingsAreCorrect() {
        XCTAssertEqual(BirdTypography.textAlignment(for: .title), .center)
        XCTAssertEqual(BirdTypography.textAlignment(for: .subtitle), .center)
        XCTAssertEqual(BirdTypography.textAlignment(for: .body), .leading)
        XCTAssertEqual(BirdTypography.textAlignment(for: .caption), .leading)
    }
}
