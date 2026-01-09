//
//  LocationService.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import CoreLocation
import Foundation

enum LocationAuthorizationStatus: Sendable {
    case notDetermined, authorized, denied, restricted
}

protocol LocationServiceProtocol : AnyObject, Sendable {
    func authorizationStatus() -> LocationAuthorizationStatus
    func requestAuthorization() async throws -> LocationAuthorizationStatus
}
