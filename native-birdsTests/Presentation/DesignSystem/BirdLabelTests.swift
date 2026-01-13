//
//  BirdLabelTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
@testable import native_birds

final class BirdLabelTests: XCTestCase {
    
    func test_birdLabelSuccessf() {
        let expectedText = "Common Swift"
        let expectedStyle = BirdLabelStyle.title
        
        let sut = BirdLabel(text: expectedText, style: expectedStyle)
        
        XCTAssertEqual(sut.text, expectedText)
        XCTAssertEqual(sut.style, expectedStyle)
    }
}
