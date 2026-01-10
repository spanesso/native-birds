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
    func test_fontStyleSuccessValues() {
        let styles: [(BirdLabelStyle, CGFloat)] = [
            (.title, 52),
            (.subtitle, 20),
            (.body, 16),
            (.caption, 13)
        ]
        
        for (style, expectedSize) in styles {
            let font = BirdTypography.font(for: style)
            XCTAssertEqual(font, .system(size: expectedSize, weight: getExpectedWeight(for: style)),
                           "Font size for \(style) should be \(expectedSize)")
        }
    }

    func test_colorStyleSuccessValues() {
        XCTAssertEqual(BirdTypography.color(for: .title), .white)
        XCTAssertEqual(BirdTypography.color(for: .body), BirdTheme.deepBlack)
        
        let expectedSubtitleColor = Color.white.opacity(0.85)
        XCTAssertEqual(BirdTypography.color(for: .subtitle), expectedSubtitleColor)
    }

    func test_alignmentForStyleSuccesss() {
        XCTAssertEqual(BirdTypography.alignment(for: .title), .center)
        XCTAssertEqual(BirdTypography.alignment(for: .subtitle), .center)
        XCTAssertEqual(BirdTypography.alignment(for: .body), .leading)
        XCTAssertEqual(BirdTypography.alignment(for: .caption), .leading)
    }

    private func getExpectedWeight(for style: BirdLabelStyle) -> Font.Weight {
        switch style {
            case .title: return .heavy
            default: return .regular
        }
    }
}
