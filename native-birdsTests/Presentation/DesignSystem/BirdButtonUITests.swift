//
//  BirdButtonUITests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
@testable import native_birds

final class BirdButtonUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        app.launch()
    }

    func test_birdButton_shouldBeDisabled_whenInLoadingState() {
        let button = app.buttons["primary_button_identifier"]
        XCTAssertFalse(button.isEnabled, "The button should be disabled when the state is .loading")
    }
}
