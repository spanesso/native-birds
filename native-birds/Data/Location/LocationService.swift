//
//  LocationService.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import CoreLocation
import Foundation
import UIKit

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    private var authContinuation: CheckedContinuation<LocationAuthorizationStatus, Never>?
    
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAuthorization() async -> LocationAuthorizationStatus {
        let current = authorizationStatus()
        if current != .notDetermined {
            return current
        }
        
        if authContinuation != nil { return .notDetermined }
        
        return await withCheckedContinuation { continuation in
            self.authContinuation = continuation
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let cont = authContinuation else {
            return
        }
        authContinuation = nil
        cont.resume(returning: authorizationStatus())
    }
    
    func authorizationStatus() -> LocationAuthorizationStatus {
        switch manager.authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        @unknown default:
            return .denied
        }
    }
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        let status = authorizationStatus()
        guard status == .authorized else {
            throw LocationServiceError.notAuthorized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let cont = locationContinuation else { return }
        locationContinuation = nil
        
        if let coordinate = locations.first?.coordinate {
            cont.resume(returning: coordinate)
        } else {
            cont.resume(throwing: LocationServiceError.failedToGetLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let cont = locationContinuation else { return }
        locationContinuation = nil
        cont.resume(throwing: error)
    }
}
