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
    private let splashFlowInteractor: SplashFlowInteractorProtocol
    private let locationService: LocationServiceProtocol
    
    init(
        router: RouterProtocol,
        splashFlowInteractor: SplashFlowInteractorProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.router = router
        self.splashFlowInteractor = splashFlowInteractor
        self.locationService = locationService
    }
    
    func startAdventureTapped() {
        executeMainWorkflow()
    }
    
    func retryKeysTapped() {
        executeMainWorkflow()
    }
    
    private func executeMainWorkflow() {
        Task {
            state = .validatingRemoteConfig
            
            let result = await splashFlowInteractor.execute()
            
            switch result {
            case .success:
                state = .readyToNavigate
                router.push(.birdList)
                
            case .locationDenied:
                handleError(
                    message: AppCopy.Splash.Location.permissionRequiredMessage,
                    isLocationError: true
                )
                
            case .remoteConfigIncomplete:
                handleError(
                    message: AppCopy.Splash.RemoteConfig.missingKeysMessage,
                    isLocationError: false
                )
            }
        }
    }
    
    private func handleError(message: String, isLocationError: Bool) {
        self.modalMessage = message
        if isLocationError {
            self.showDeniedModal = true
        } else {
            self.showKeysModal = true
        }
        self.state = .idle
    }
    
    func retryPermissionTapped() {
        locationService.openAppSettings()
    }
}
