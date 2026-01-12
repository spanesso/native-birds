//
//  BirdDesignSystemTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdDesignSystemTests: XCTestCase {
    
    func test_spacing_constants_areConsistent() {
        XCTAssertEqual(BirdSpacing.screenHorizontal, 26)
        XCTAssertEqual(BirdSpacing.listItemPadding, 14)
        XCTAssertEqual(BirdSpacing.listItemImageSize, 72)
    }
    
    func test_size_constants_areCorrect() {
        XCTAssertEqual(BirdSize.splashImage, 400)
    }
    
    func test_label_initialization_setsPropertiesCorrectly() {
        let expectedText = "Common Swift"
        let expectedStyle: BirdLabelStyle = .title
        
        let sut = BirdLabel(text: expectedText, style: expectedStyle)
        
        XCTAssertEqual(sut.text, expectedText)
        XCTAssertEqual(sut.style, expectedStyle)
    }
}
