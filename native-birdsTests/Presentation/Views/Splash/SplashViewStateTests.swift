//
//  SplashViewStateTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class SplashViewStateTests: XCTestCase {
    
    func test_splashViewState_equality() {
        XCTAssertEqual(SplashViewState.idle, .idle)
        XCTAssertEqual(SplashViewState.requestingPermission, .requestingPermission)
        XCTAssertEqual(SplashViewState.validatingRemoteConfig, .validatingRemoteConfig)
        XCTAssertEqual(SplashViewState.readyToNavigate, .readyToNavigate)
        
        let error1 = SplashViewState.failed("error")
        let error2 = SplashViewState.failed("error")
        let error3 = SplashViewState.failed("different")
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
        XCTAssertNotEqual(error1, .idle)
    }
}
