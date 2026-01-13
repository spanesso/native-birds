//
//  LocationServiceMock.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import CoreLocation
@testable import native_birds

final class LocationServiceMock: LocationServiceProtocol, @unchecked Sendable {
    
    var requestAuthorizationResult: LocationAuthorizationStatus = .authorized
    var authorizationStatusResult: LocationAuthorizationStatus = .authorized
    var currentCoordinatesResult: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var shouldThrowError = false
    
    var requestAuthorizationCalled = false
    var openAppSettingsCalled = false
    var getCurrentCoordinatesCalled = false
    
    func requestAuthorization() async -> LocationAuthorizationStatus {
        requestAuthorizationCalled = true
        return requestAuthorizationResult
    }
    
    func authorizationStatus() -> LocationAuthorizationStatus {
        return authorizationStatusResult
    }
    
    func openAppSettings() {
        openAppSettingsCalled = true
    }
    
    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        getCurrentCoordinatesCalled = true
        if shouldThrowError {
            throw LocationServiceError.failedToGetLocation
        }
        return currentCoordinatesResult
    }
}
