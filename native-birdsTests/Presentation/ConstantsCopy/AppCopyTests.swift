//
//  AppCopyTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import XCTest
@testable import native_birds

final class AppCopyTests: XCTestCase {
    
    func test_global_strings_areNotEmpty() {
        XCTAssertFalse(AppCopy.Global.cancel.isEmpty)
        XCTAssertFalse(AppCopy.Global.retry.isEmpty)
        
        XCTAssertEqual(AppCopy.Global.cancel, "Cancel")
        XCTAssertEqual(AppCopy.Global.retry, "Retry")
    }
    
    func test_error_strings_containExpectedMessages() {
        XCTAssertTrue(AppCopy.Error.missingINaturalistToken.contains("iNaturalist"))
        XCTAssertTrue(AppCopy.Error.missingLocation.contains("location"))
    }
    
    func test_splash_view_copy_isCorrect() {
        XCTAssertEqual(AppCopy.Splash.SplashViewCopy.title, "Native Birds")
        XCTAssertEqual(AppCopy.Splash.SplashViewCopy.subTitle, "Listen to the world of birds")
    }
    
    func test_remoteConfig_error_messages_areValid() {
        XCTAssertFalse(AppCopy.Splash.RemoteConfig.missingKeysTitle.isEmpty)
        XCTAssertTrue(AppCopy.Splash.RemoteConfig.missingKeysMessage.contains("Firebase"))
    }
    
    func test_location_permission_copy_isInformative() {
        XCTAssertEqual(AppCopy.Splash.Location.permissionRequiredTitle, "Location Permission Required")
        XCTAssertTrue(AppCopy.Splash.Location.permissionRequiredMessage.contains("GPS"))
    }
    
    func test_birdList_ui_copy_isCorrect() {
        XCTAssertEqual(AppCopy.BirdList.BirdListViewCopy.title, "Nearby Birds")
        XCTAssertFalse(AppCopy.BirdList.BirdListViewCopy.loading.isEmpty)
        XCTAssertEqual(AppCopy.BirdList.BirdListViewCopy.empty, "No birds found nearby.")
    }
    
    func test_splash_actions_isCorrect() {
        XCTAssertEqual(AppCopy.Splash.Actions.startAdventure, "Start Adventure")
    }
    
    func test_birdDetail_error_strings_areCorrect() {
        XCTAssertEqual(AppCopy.BirdDetail.BirdDetailViewCopy.errorAPIKey, "Missing Xeno-canto API key from Remote Config.")
        XCTAssertEqual(AppCopy.BirdDetail.BirdDetailViewCopy.errorAudio, "No audio recording found for this bird.")
    }
    
    func test_birdDetail_strings_areNotEmpty() {
        XCTAssertFalse(AppCopy.BirdDetail.BirdDetailViewCopy.errorAPIKey.isEmpty)
        XCTAssertFalse(AppCopy.BirdDetail.BirdDetailViewCopy.errorAudio.isEmpty)
    }
}
