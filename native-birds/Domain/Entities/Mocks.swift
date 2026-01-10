//
//  Mocks.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation
import CoreLocation
import UIKit

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
    private let coordinate: CLLocationCoordinate2D

    init(
        status: LocationAuthorizationStatus,
        coordinate: CLLocationCoordinate2D = .init(latitude: 6.2106, longitude: -75.5050)
    ) {
        self.status = status
        self.coordinate = coordinate
    }

    func authorizationStatus() -> LocationAuthorizationStatus { status }
    func requestAuthorization() async -> LocationAuthorizationStatus { status }
    func openAppSettings() { }

    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        guard status == .authorized else { throw LocationServiceError.notAuthorized }
        return coordinate
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

struct MockFetchNearbyBirdsUseCase: FetchNearbyBirdsUseCaseProtocol {

    func execute(
        lat: Double,
        lng: Double,
        page: Int,
        perPage: Int,
        bearerToken: String
    ) async throws -> PagedResult<Bird> {

        let birds = Bird.mockList()

        let hasMore = (page * perPage) < 100

        return PagedResult(
            items: birds,
            hasMore: hasMore
        )
    }
}

struct MockBirdImageCache: BirdImageCacheProtocol {
    func store(_ image: UIImage, for url: URL) async { }
    
    func image(for url: URL) -> UIImage? { nil }
    func save(_ image: UIImage, for url: URL) {}
}
