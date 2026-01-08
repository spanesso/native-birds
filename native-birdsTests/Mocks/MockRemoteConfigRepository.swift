//
//  MockRemoteConfigRepository.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation
@testable import native_birds

final class MockRemoteConfigRepository: RemoteConfigProtocol {
    
    var shouldSucceed = true
    var mockKeys = APIKeys(
        inatToken: "mock_inat_token_key",
        xenoToken: "mock_xeno_token_key"
    )
    
    var activateCalled = false

    func activate() async -> Bool {
        activateCalled = true
        return shouldSucceed
    }

    func getAPIKeys() async -> APIKeys {
        return mockKeys
    }
}
