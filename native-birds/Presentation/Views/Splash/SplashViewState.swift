//
//  SplashViewState.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

enum SplashViewState: Equatable {
    case idle
    case requestingPermission
    case validatingRemoteConfig
    case readyToNavigate
    case failed(String)
}
