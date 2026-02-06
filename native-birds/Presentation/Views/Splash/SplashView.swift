//
//  SplashView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    
    var body: some View {
        SplashContentView(
            state: viewModel.state,
            delegate : self
        )
        .navigationBarBackButtonHidden(true)
        .birdAlert(
            isPresented: $viewModel.showDeniedModal,
            title: AppCopy.Splash.Location.permissionRequiredTitle,
            message: viewModel.modalMessage
        ) {
            viewModel.retryPermissionTapped()
        }
        .birdAlert(
            isPresented: $viewModel.showKeysModal,
            title: AppCopy.Splash.RemoteConfig.missingKeysTitle,
            message: viewModel.modalMessage
        ) {
            viewModel.retryKeysTapped()
        }
    }
}

extension SplashView: SplashViewDelegate {
    func onStartAdventure(){
        viewModel.startAdventureTapped()
    }
}
