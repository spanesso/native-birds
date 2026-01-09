//
//  SplashViewModel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    
    enum SplashViewState: Equatable {
        case idle
        case requestingPermission
        case validatingRemoteConfig
        case readyToNavigate
        case failed(String)
    }
    
    private let router: AppRouter
    private let remoteConfig: RemoteConfigProtocol
    private let locationService: LocationServiceProtocol
    
}
