//
//  Untitled.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

@testable import native_birds

final class MockRemoteConfigTests: RemoteConfigProtocol {

    var token: String?

    init(token: String?) {
        self.token = token
    }

    func activate() async -> Bool {
        true
    }

    func getAPIKeys() async -> APIKeys {
        APIKeys(inatToken: token, xenoToken: nil)
    }
}
