//
//  AppCopyTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
@testable import native_birds

final class AppCopyTests: XCTestCase {

    func test_globalCopy_stringsAreNotEmpty() {
        XCTAssertFalse(AppCopy.Global.cancel.isEmpty, "Global cancel string should not be empty")
        XCTAssertFalse(AppCopy.Global.retry.isEmpty, "Global retry string should not be empty")
    }

    func test_splashCopy_titlesAndMessagesAreCorrect() {
        XCTAssertEqual(AppCopy.Splash.SplashViewCopy.title, "Native Birds")
        XCTAssertEqual(AppCopy.Splash.Actions.startAdventure, "Start Adventure")
        
        XCTAssertGreaterThan(AppCopy.Splash.RemoteConfig.missingKeysMessage.count, 20, "Remote config error message should be descriptive")
    }

    func test_splashLocationCopy_hasRequiredInformation() {
        let title = AppCopy.Splash.Location.permissionRequiredTitle
        let message = AppCopy.Splash.Location.permissionRequiredMessage
        
        XCTAssertFalse(title.isEmpty)
        XCTAssertTrue(message.contains("GPS"), "Location message should mention GPS for user clarity")
    }

    func test_birdListCopy_isCorrect() {
        XCTAssertEqual(AppCopy.BirdList.BirdListViewCopy.title, "Nearby Birds")
        XCTAssertEqual(AppCopy.BirdList.BirdListViewCopy.subTitle, "Discover and listen to the world of birds")
    }
}
