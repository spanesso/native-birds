//
//  LocationService.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import CoreLocation
import Foundation

enum LocationAuthorizationStatus: Sendable {
    case authorized, denied, restricted
}

protocol LocationService : AnyObject, Sendable {
    func requestAuthorization() async throws -> LocationAuthorizationStatus
}
