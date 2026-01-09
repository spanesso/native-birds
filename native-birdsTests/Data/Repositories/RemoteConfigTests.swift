//
//  RemoteConfigTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import XCTest
@testable import native_birds

final class RemoteConfigLogicTests: XCTestCase {
    
    func test_getRemoteApiKeys() async{
        let mockRemoteConfig = MockRemoteConfigRepository()
        mockRemoteConfig.mockKeys = APIKeys(inatToken: "mock_inat_token_key", xenoToken: "mock_xeno_token_key")
        
        let keys = await mockRemoteConfig.getAPIKeys()
        
        XCTAssertEqual(keys.inatToken, "mock_inat_token_key")
        XCTAssertEqual(keys.xenoToken, "mock_xeno_token_key")
        
    }
}
