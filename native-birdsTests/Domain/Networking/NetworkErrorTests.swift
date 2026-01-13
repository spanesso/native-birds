//
//  NetworkErrorTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class NetworkErrorTests: XCTestCase {
    
    func test_networkError_equality() {
        XCTAssertEqual(NetworkError.decoding, NetworkError.decoding)
        XCTAssertEqual(NetworkError.invalidResponse, NetworkError.invalidResponse)
        XCTAssertEqual(NetworkError.serverError(500), NetworkError.serverError(500))
        XCTAssertEqual(NetworkError.unauthorized, NetworkError.unauthorized)
        
        XCTAssertNotEqual(NetworkError.serverError(500), NetworkError.serverError(404))
        XCTAssertNotEqual(NetworkError.decoding, NetworkError.invalidResponse)
    }
}
