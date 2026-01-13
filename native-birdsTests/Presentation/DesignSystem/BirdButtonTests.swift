//
//  BirdButtonTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
@testable import native_birds

final class BirdButtonTests: XCTestCase {
    
    func test_button_state_equality() {
        XCTAssertEqual(BirdButtonState.normal, .normal)
        XCTAssertNotEqual(BirdButtonState.loading, .disabled)
    }
    
    func test_button_initialization_setsTitleAndState() {
        let title = "Confirm"
        let sut = BirdButton(title: title, state: .loading, action: {})
        
        XCTAssertEqual(sut.title, title)
        XCTAssertEqual(sut.state, .loading)
    }
    
    func test_button_accessibilityIdentifier_isGeneratedCorrectly() {
        let title = "Play"
        let sut = BirdButton(title: title, action: {})
        
        XCTAssertEqual("bird_button_play", "bird_button_\(title.lowercased())")
    }
}
