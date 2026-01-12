//
//  Mocks.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation
import SwiftUI
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
            preferredCommonName: "Peregrine Falcon",
            name: "Falco peregrinus",
            defaultPhotoUrl: nil,
            defaultPhotoMediumUrl: nil,
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Peregrine_falcon")
        )
    }

    static func mockList() -> [Bird] {
        [
            Bird(
                taxonId: 1,
                preferredCommonName: "Inca Jay",
                name: "Cyanocorax yncas",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil,
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/bir-url")
            ),
            Bird(
                taxonId: 2,
                preferredCommonName: "Great Kiskadee",
                name: "Pitangus sulphuratus",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil,
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/bir-url")
            ),
            Bird(
                taxonId: 3,
                preferredCommonName: "Peregrine Falcon",
                name: "Falco peregrinus",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil,
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/bir-url")
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

class MockImageCache: BirdImageCacheProtocol {
    func image(for url: URL) async -> UIImage? { nil }
    func store(_ image: UIImage, for url: URL) async {}
}

struct MockBirdImageCache: BirdImageCacheProtocol {
    func store(_ image: UIImage, for url: URL) async { }
    
    func image(for url: URL) -> UIImage? { nil }
    func save(_ image: UIImage, for url: URL) {}
}


final class MockLocationServiceTests: LocationServiceProtocol {

    var status: LocationAuthorizationStatus = .authorized
    var coordinate = CLLocationCoordinate2D(latitude: 6.21, longitude: -75.50)

    func authorizationStatus() -> LocationAuthorizationStatus {
        status
    }

    func requestAuthorization() async -> LocationAuthorizationStatus {
        status
    }

    func openAppSettings() {}

    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        if status != .authorized {
            throw LocationServiceError.notAuthorized
        }
        return coordinate
    }
}


struct MockFetchRecording: FetchBirdRecordingUseCaseProtocol {
    func execute(scientificName: String, apiKey: String) async throws -> BirdRecording? {
        return BirdRecording(
            id: "1", genus: "Pitangus", species: "sulphuratus",
            commonName: "Great Kiskadee", audioUrl: "",
            quality: "A", type: "sound", duration: "30"
        )
    }
}

struct MockAudioCache: BirdAudioCacheProtocol {
    func fileURL(for remoteURL: URL) async -> URL? { nil }
    func storeDownloadedFile(from tempURL: URL, remoteURL: URL) async throws -> URL { tempURL }
}

struct MockDownloader: AudioDownloadServiceProtocol {
    func download(remoteURL: URL, onProgress: @escaping @Sendable (Double) -> Void) async throws -> URL {
        return URL(fileURLWithPath: "")
    }
}

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}



#if DEBUG



@MainActor
func makeBirdsListViewModel(
    state: BirdsListUIState,
    birds: [Bird] = [],
    canLoadMore: Bool = false
) -> BirdsListViewModel {

    let vm = BirdsListViewModel(
        locationService: MockLocationService(status: .authorized),
        remoteConfig: MockRemoteConfig(ready: true),
        fetchNearbyBirds: MockFetchNearbyBirdsUseCase()
    )

    vm._setPreview(
        state: state,
        birds: birds,
        canLoadMore: canLoadMore
    )

    return vm
}

#endif


