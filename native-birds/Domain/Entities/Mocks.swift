//
//  Mocks.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation
import CoreLocation

@MainActor
final class MockRouter: RouterProtocol {
    func push(_ route: AppRoute) { }
}

final class MockRemoteConfig: RemoteConfigProtocol {

    private let ready: Bool

    init(ready: Bool) {
        self.ready = ready
    }

    func activate() async -> Bool {
        return true
    }

    func getAPIKeys() async -> APIKeys {
        ready
        ? APIKeys(inatToken: "mock", xenoToken: "mock")
        : APIKeys(inatToken: nil, xenoToken: nil)
    }
}

final class MockLocationService: LocationServiceProtocol {

    private let status: LocationAuthorizationStatus

    init(status: LocationAuthorizationStatus) {
        self.status = status
    }

    func authorizationStatus() -> LocationAuthorizationStatus {
        status
    }

    func requestAuthorization() async -> LocationAuthorizationStatus {
        status
    }
}
 
extension Bird {
    static func mock() -> Bird {
        Bird(
            taxonId: 1,
            englishCommonName: "Peregrine Falcon",
            name: "Peregrine Falcon",
            defaultPhotoUrl: nil,
            defaultPhotoMediumUrl: nil
        )
    }
    
    static func mockList() -> [Bird] {
        [
            Bird(
                taxonId: 1,
                englishCommonName: "Inca Jay",
                name: "Cyanocorax yncas",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil
            ),
            Bird(
                taxonId: 2,
                englishCommonName: "Great Kiskadee",
                name: "Pitangus sulphuratus",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil
            ),
            Bird(
                taxonId: 3,
                englishCommonName: "Peregrine Falcon",
                name: "Peregrine Falcon",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil
            )
        ]
    }
}
