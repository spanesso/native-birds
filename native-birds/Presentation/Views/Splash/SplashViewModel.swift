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
            await checkIfContinueIsPossible()
        }
    }
    
    func startAdventureTapped() {
        Task {
            await requestPermissionAndContinue()
        }
    }
    
    func retryPermissionTapped() {
        Task {
            await requestPermissionAndContinue()
        }
    }
    
    func retryKeysTapped() {
        Task {
            await validateRemoteConfigKeys()
        }
    }
    
    private func checkIfContinueIsPossible() async {
        if locationService.authorizationStatus() == .authorized {
            await validateRemoteConfigKeys()
        }
    }
    
    private func requestPermissionAndContinue() async {
        state = .requestingPermission
        let status = await locationService.requestAuthorization()
        
        guard status == .authorized else {
            modalMessage = AppCopy.Splash.Location.permissionRequiredMessage
            showDeniedModal = true
            state = .idle
            return
        }
        
        await validateRemoteConfigKeys()
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
