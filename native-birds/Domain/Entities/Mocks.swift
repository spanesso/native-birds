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

final class MockRemoteConfig: RemoteConfigProtocol, @unchecked Sendable {
    var activateResult = true
    var apiKeys = APIKeys(inatToken: "mock", xenoToken: "mock")
    var activateCalled = false
    
    func activate() async -> Bool {
        activateCalled = true
        return activateResult
    }
    
    func getAPIKeys() async -> APIKeys {
        return apiKeys
    }
}

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    var status: LocationAuthorizationStatus = .notDetermined
    var coordinate = CLLocationCoordinate2D(latitude: 6.2106, longitude: -75.5050)
    
    var requestAuthorizationCalled = false
    var openAppSettingsCalled = false

    func authorizationStatus() -> LocationAuthorizationStatus {
        return status
    }

    func requestAuthorization() async -> LocationAuthorizationStatus {
        requestAuthorizationCalled = true
        return status
    }

    func openAppSettings() {
        openAppSettingsCalled = true
    }

    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        if status != .authorized {
            throw LocationServiceError.notAuthorized
        }
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
            Bird(taxonId: 1, preferredCommonName: "Inca Jay", name: "Cyanocorax yncas", defaultPhotoUrl: nil, defaultPhotoMediumUrl: nil, wikipediaURL: nil),
            Bird(taxonId: 2, preferredCommonName: "Great Kiskadee", name: "Pitangus sulphuratus", defaultPhotoUrl: nil, defaultPhotoMediumUrl: nil, wikipediaURL: nil)
        ]
    }
}

final class MockFetchNearbyBirdsUseCase: FetchNearbyBirdsUseCaseProtocol {
    var resultToReturn: PagedResult<Bird>?
    func execute(lat: Double, lng: Double, page: Int, perPage: Int, bearerToken: String) async throws -> PagedResult<Bird> {
        return resultToReturn ?? PagedResult(items: Bird.mockList(), hasMore: false)
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

final class MockAudioCache: BirdAudioCacheProtocol, @unchecked Sendable {
    var fileURLToReturn: URL?
    var storedURLToReturn: URL?
    var storeCalled = false

    func fileURL(for remoteURL: URL) async -> URL? {
        return fileURLToReturn
    }

    func storeDownloadedFile(from tempURL: URL, remoteURL: URL) async throws -> URL {
        storeCalled = true
        return storedURLToReturn ?? tempURL
    }
}

final class MockFetchRecordingUseCase: FetchBirdRecordingUseCaseProtocol {
    var recordingToReturn: BirdRecording?
    var shouldThrow = false
    
    func execute(scientificName: String, apiKey: String) async throws -> BirdRecording? {
        if shouldThrow {
            throw NetworkError.unknown
        }
        return recordingToReturn
    }
}

final class MockAudioDownloadService: AudioDownloadServiceProtocol {
    var urlToReturn: URL!
    var downloadCalled = false
    
    func download(remoteURL: URL, onProgress: @escaping @Sendable (Double) -> Void) async throws -> URL {
        downloadCalled = true
        onProgress(1.0)
        return urlToReturn
    }
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


extension BirdRecording {
    static func mock() -> BirdRecording {
        BirdRecording(
            id: "1", genus: "Test", species: "Test",
            commonName: "Test Bird", audioUrl: "https://test.com/audio.mp3",
            quality: "A", type: "sound", duration: "10"
        )
    }
}

#if DEBUG

@MainActor
func makeBirdsListViewModel(
    state: BirdsListUIState,
    birds: [Bird] = [],
    canLoadMore: Bool = false
) -> BirdsListViewModel {
    
    let mockLocation = MockLocationService()
    let mockRemote = MockRemoteConfig()
    let mockUseCase = MockFetchNearbyBirdsUseCase()
    
    mockLocation.status = .authorized
    mockRemote.activateResult = true
    
    let vm = BirdsListViewModel(
        locationService: mockLocation,
        remoteConfig: mockRemote,
        fetchNearbyBirds: mockUseCase
    )
    
    vm._setPreview(
        state: state,
        birds: birds,
        canLoadMore: canLoadMore
    )
    
    return vm
}

#endif


