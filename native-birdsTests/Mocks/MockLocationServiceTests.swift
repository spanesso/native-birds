//
//  MockLocationServiceTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import CoreLocation
@testable import native_birds

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
