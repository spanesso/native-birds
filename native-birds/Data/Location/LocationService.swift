//
//  LocationService.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import CoreLocation
import Foundation

final class LocationServiceImpl: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAuthorization() async -> LocationAuthorizationStatus {
        return  await withCheckedContinuation { cont in
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func authorizeStatus() -> LocationAuthorizationStatus {
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse: return .authorized
            case .denied: return .denied
            case .restricted: return .restricted
            default: return .denied
        }
    }
    
    
}
