//
//  SplashView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI

import SwiftUI

struct SplashView: View {
    
    @StateObject var viewModel: SplashViewModel
    
    @ViewBuilder
    private var birdImage: some View {
        if let uiImage = UIImage(named: "inca_jay") {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "bird.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white.opacity(0.85))
                .padding(.horizontal, 60)
        }
    }
    
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                BirdTheme.primaryGreen,
                BirdTheme.electricBlue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 16) {
                Spacer(minLength: 40)
                
                VStack(spacing: 10) {
                    Text(AppCopy.Splash.SplashViewCopy.title)
                        .font(.system(size: 52, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(AppCopy.Splash.SplashViewCopy.subTitle)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 28)
                
                Spacer()
                
                birdImage
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 22)
                
                Spacer()
                
                Button(action: { viewModel.startAdventureTapped() }) {
                    HStack {
                        if viewModel.state == .requestingPermission || viewModel.state == .validatingRemoteConfig {
                            ProgressView().tint(BirdTheme.deepBlack)
                        }
                        Text(AppCopy.Splash.Actions.startAdventure)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(BirdTheme.deepBlack)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(BirdTheme.accentYellow)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 6)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 26)
                .disabled(viewModel.state == .requestingPermission || viewModel.state == .validatingRemoteConfig)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarBackButtonHidden(true)
        .alert(AppCopy.Splash.Location.permissionRequiredTitle,
               isPresented: $viewModel.showDeniedModal) {
            Button(AppCopy.Global.retry) { viewModel.retryPermissionTapped() }
            Button(AppCopy.Global.cancel, role: .cancel) { }
        } message: {
            Text(viewModel.modalMessage)
        }
        .alert(AppCopy.Splash.RemoteConfig.missingKeysTitle, isPresented: $viewModel.showKeysModal) {
            Button(AppCopy.Global.retry) { viewModel.retryKeysTapped() }
            Button(AppCopy.Global.cancel, role: .cancel) { }
        } message: {
            Text(viewModel.modalMessage)
        }
    }
    
}

#Preview("Splash – Idle") {
    SplashView(
        viewModel: SplashViewModel(
            router: MockRouter(),
            remoteConfig: MockRemoteConfig(ready: true),
            locationService: MockLocationService(status: .notDetermined)
        )
    )
}

