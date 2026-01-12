//
//  APIKeysTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class APIKeysTests: XCTestCase {
    
    func test_isApiKeysComplete_withValidTokens_returnsTrue() {
        let sut = APIKeys(inatToken: "valid_inat_token", xenoToken: "valid_xeno_token")
        
        XCTAssertTrue(sut.isApiKeysComplete)
    }
    
    func test_isApiKeysComplete_withNilInatToken_returnsFalse() {
        let sut = APIKeys(inatToken: nil, xenoToken: "valid_xeno_token")
        
        XCTAssertFalse(sut.isApiKeysComplete)
    }
    
    func test_isApiKeysComplete_withEmptyXenoToken_returnsFalse() {
        let sut = APIKeys(inatToken: "valid_inat_token", xenoToken: "")
        
        XCTAssertFalse(sut.isApiKeysComplete)
    }
    
    func test_isApiKeysComplete_withBothTokensMissing_returnsFalse() {
        let sut = APIKeys(inatToken: nil, xenoToken: nil)
        
        XCTAssertFalse(sut.isApiKeysComplete)
    }
    
    func test_apiKeys_equality_worksAsExpected() {
        let keys1 = APIKeys(inatToken: "token_a", xenoToken: "token_b")
        let keys2 = APIKeys(inatToken: "token_a", xenoToken: "token_b")
        let keys3 = APIKeys(inatToken: "token_different", xenoToken: "token_b")
        
        XCTAssertEqual(keys1, keys2)
        XCTAssertNotEqual(keys1, keys3)
    }
}
