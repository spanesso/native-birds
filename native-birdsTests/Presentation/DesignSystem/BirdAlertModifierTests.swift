//
//  BirdAlertModifierTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdAlertModifierTests: XCTestCase {
    var primaryActionCalled = false
    
    override func setUp() {
        super.setUp()
        primaryActionCalled = false
    }

    func test_birdAlert_primaryAction_isTriggered() {
        let expectation = XCTestExpectation(description: "Primary action should be called")
        
        let modifier = BirdAlertModifier(
            isPresented: .constant(true),
            title: "Test Title",
            message: "Test Message",
            primaryButtonTitle: "Retry",
            secondaryButtonTitle: "Cancel",
            onPrimaryAction: {
                self.primaryActionCalled = true
                expectation.fulfill()
            }
        )

        modifier.onPrimaryAction()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(primaryActionCalled)
    }
}
