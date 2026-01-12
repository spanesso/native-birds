//
//  SplashViewModel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation
internal import Combine

@MainActor
final class SplashViewModel: ObservableObject {
    
    @Published private(set) var state: SplashViewState = .idle
    @Published var showDeniedModal: Bool = false
    @Published var showKeysModal: Bool = false
    @Published var modalMessage: String = ""
    
    private let router: RouterProtocol
    private let remoteConfig: RemoteConfigProtocol
    private let locationService: LocationServiceProtocol
    
    init(
        router: RouterProtocol,
        remoteConfig: RemoteConfigProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.router = router
        self.remoteConfig = remoteConfig
        self.locationService = locationService
    }
    
    func onAppear() {
        Task {
            _ = await remoteConfig.activate()
        }
    }
    
    func startAdventureTapped() {
        Task {
            await requestPermissionAndContinue()
        }
    }
    
    func retryPermissionTapped() {
        locationService.openAppSettings()
    }
    
    func retryKeysTapped() {
        Task {
            await validateRemoteConfigKeys()
        }
    }
    
    private func requestPermissionAndContinue() async {
        state = .requestingPermission
        
        let currentStatus = locationService.authorizationStatus()
        
        switch currentStatus {
            case .notDetermined:
                let newStatus = await locationService.requestAuthorization()
                guard newStatus == .authorized else {
                    modalMessage = AppCopy.Splash.Location.permissionRequiredMessage
                    showDeniedModal = true
                    state = .idle
                    return
                }
                await validateRemoteConfigKeys()
                
            case .denied, .restricted:
                modalMessage = AppCopy.Splash.Location.permissionRequiredMessage
                showDeniedModal = true
                state = .idle
                
            case .authorized:
                await validateRemoteConfigKeys()
        }
    }
    
    private func validateRemoteConfigKeys() async {
        state = .validatingRemoteConfig
        _ = await remoteConfig.activate()
        
        let keys = await remoteConfig.getAPIKeys()
        guard keys.isApiKeysComplete else {
            modalMessage = AppCopy.Splash.RemoteConfig.missingKeysMessage
            showKeysModal = true
            state = .idle
            return
        }
        
        state = .readyToNavigate
        nativagateToNextView()
    }
    
    private func nativagateToNextView() {
        router.push(.birdList)
    }
}
