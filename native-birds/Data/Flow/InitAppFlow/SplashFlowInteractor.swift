//
//  SplashFlowInteractor.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

protocol SplashFlowInteractorProtocol: Sendable {
    func execute() async -> SplashFlowInteractorResult
}

enum SplashFlowInteractorResult {
    case success
    case locationDenied
    case remoteConfigIncomplete
}

final class SplashFlowInteractor: SplashFlowInteractorProtocol {
    private let locationService: LocationServiceProtocol
    private let remoteConfig: RemoteConfigProtocol
    
    init(locationService: LocationServiceProtocol, remoteConfig: RemoteConfigProtocol) {
        self.locationService = locationService
        self.remoteConfig = remoteConfig
    }
    
    func execute() async -> SplashFlowInteractorResult {
        let status = locationService.authorizationStatus()
        
        if status == .notDetermined {
            let newStatus = await locationService.requestAuthorization()
            if newStatus != .authorized { return .locationDenied }
        } else if status == .denied || status == .restricted {
            return .locationDenied
        }
        
        _ = await remoteConfig.activate()
        let keys = await remoteConfig.getAPIKeys()
        
        guard keys.isApiKeysComplete else {
            return .remoteConfigIncomplete
        }
        
        return .success
    }
}
