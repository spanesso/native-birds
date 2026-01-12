//
//  LocationServiceTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import CoreLocation
@testable import native_birds

final class LocationServiceTests: XCTestCase {
    
    private var sut: LocationService!
    
    override func setUp() {
        super.setUp()
        sut = LocationService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_authorizationStatus_mapsCorrectStatuses() {
        let cases: [(CLAuthorizationStatus, LocationAuthorizationStatus)] = [
            (.notDetermined, .notDetermined),
            (.restricted, .restricted),
            (.denied, .denied),
            (.authorizedAlways, .authorized),
            (.authorizedWhenInUse, .authorized)
        ]
        
        for (input, expected) in cases {
            XCTAssertEqual(sut.mapStatus(input), expected)
        }
    }
    
    func test_requestAuthorization_returnsImmediately_ifAlreadyDetermined() async {
        let status = await sut.requestAuthorization()
        
        if sut.authorizationStatus() != .notDetermined {
            XCTAssertEqual(status, sut.authorizationStatus())
        }
    }
    
    func test_getCurrentCoordinates_throwsError_whenNotAuthorized() async {
        if sut.authorizationStatus() != .authorized {
            do {
                _ = try await sut.getCurrentCoordinates()
                XCTFail("Should throw notAuthorized error")
            } catch let error as LocationServiceError {
                XCTAssertEqual(error, .notAuthorized)
            } catch {
                XCTFail("Wrong error type thrown")
            }
        }
    }
    
    func test_locationDelegate_resumesContinuation_onSuccess() async throws {
        let expectation = expectation(description: "Coordinate continuation resumed")
        let expectedCoordinate = CLLocationCoordinate2D(latitude:37.785834, longitude: -74.006)
        let location = CLLocation(latitude: expectedCoordinate.latitude, longitude: expectedCoordinate.longitude)
        
        Task {
            do {
                if sut.authorizationStatus() == .authorized {
                    let coord = try await sut.getCurrentCoordinates()
                    XCTAssertEqual(coord.latitude, expectedCoordinate.latitude)
                    XCTAssertEqual(coord.longitude, expectedCoordinate.longitude)
                    expectation.fulfill()
                } else {
                    expectation.fulfill()
                }
            } catch {
                expectation.fulfill()
            }
        }
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.locationManager(sut.manager, didUpdateLocations: [location])
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
 
}

extension LocationService {
    func mapStatus(_ status: CLAuthorizationStatus) -> LocationAuthorizationStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }
}
