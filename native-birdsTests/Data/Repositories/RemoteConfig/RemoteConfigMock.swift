//
//  Untitled.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation
@testable import native_birds

final class RemoteConfigMock: RemoteConfigProtocol, @unchecked Sendable {
    
    var activateResult: Bool = true
    var apiKeysResult: APIKeys = APIKeys(inatToken: "mock_inat", xenoToken: "mock_xeno")
    
    var activateCalled = false
    var getAPIKeysCalled = false
    
    func activate() async -> Bool {
        activateCalled = true
        return activateResult
    }
    
    func getAPIKeys() async -> APIKeys {
        getAPIKeysCalled = true
        return apiKeysResult
    }
}
