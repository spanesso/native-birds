//
//  BirdButtonTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdButtonTests: XCTestCase {

    func test_birdButton_executesAction_whenTapped() {
        let expectation = XCTestExpectation(description: "Button action should be triggered")
        let sut = BirdButton(title: "Test", state: .normal) {
            expectation.fulfill()
        }
        
        sut.action()
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_birdButton_initialization_storesCorrectProperties() {
        let expectedTitle = "Adventure"
        let expectedState = BirdButtonState.loading
        
        let sut = BirdButton(title: expectedTitle, state: expectedState) { }
        
        XCTAssertEqual(sut.title, expectedTitle)
        XCTAssertEqual(sut.state, expectedState)
    }
}
