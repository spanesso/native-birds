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
                .padding(.horizontal, BirdSpacing.imageHorizontal)
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
            
            VStack(spacing: BirdSpacing.sectionVertical) {
                Spacer(minLength: BirdSpacing.large)
                
                VStack(spacing: BirdSpacing.contentVertical) {
                    BirdLabel(
                        text: AppCopy.Splash.SplashViewCopy.title,
                        style: .title
                    )
                    
                    BirdLabel(
                        text: AppCopy.Splash.SplashViewCopy.subTitle,
                        style: .subtitle
                    )
                }
                .padding(.horizontal, BirdSpacing.screenHorizontal)
                
                Spacer()
                
                birdImage
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, BirdSpacing.imageHorizontal)
                
                Spacer()
                
                if viewModel.state == .idle {
                    BirdButton(
                        title: AppCopy.Splash.Actions.startAdventure,
                        state: viewModel.state == .requestingPermission ||
                        viewModel.state == .validatingRemoteConfig
                        ? .loading
                        : .normal
                    ) {
                        viewModel.startAdventureTapped()
                    }.padding(.horizontal, BirdSpacing.screenHorizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
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

#Preview("Splash – Idle") {
    SplashView(
        viewModel: SplashViewModel(
            router: MockRouter(),
            remoteConfig: MockRemoteConfig(ready: true),
            locationService: MockLocationService(status: .notDetermined)
        )
    )
}

