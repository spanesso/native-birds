//
//  CoreDependencies.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//
import Foundation

@MainActor
final class CoreDependencies {
    let router: AppRouter
    let remoteConfig: RemoteConfigProtocol
    let locationService: LocationServiceProtocol

    init() {
        self.router = AppRouter()
        self.remoteConfig = RemoteConfigRepository()
        self.locationService = LocationService()
    }
}
