//
//  BirdFlightViewTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdFlightViewTests: XCTestCase {
    
    func test_view_initializesWithCorrectSpriteSheet() {
        let expectedSprite = "bird_animation_sheet"
        let sut = BirdFlightView(spriteSheetName: expectedSprite)
        
        XCTAssertEqual(sut.spriteSheetName, expectedSprite)
    }
}
