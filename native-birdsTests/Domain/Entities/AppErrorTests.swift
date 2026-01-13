//
//  AppErrorTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class AppErrorTests: XCTestCase {
    
    func test_appError_equality() {
        let error1 = AppError.locationFailed("Timeout")
        let error2 = AppError.locationFailed("Timeout")
        let error3 = AppError.missingLocation
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func test_appError_locationFailed_description() {
        let message = "GPS signal lost"
        let sut = AppError.locationFailed(message)
        
        XCTAssertEqual(sut.errorDescription, message)
    }
    
    func test_appError_unknown_description() {
        let message = "Critical failure"
        let sut = AppError.unknown(message)
        
        XCTAssertEqual(sut.errorDescription, message)
    }
}
