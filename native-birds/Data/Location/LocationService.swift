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
}
