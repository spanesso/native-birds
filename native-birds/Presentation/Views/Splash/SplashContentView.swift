//
//  SplashContentView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

struct SplashContentView: View {
    let state: SplashViewState
    let onStartAction: () -> Void
    
    var body: some View {
        ZStack {
            BirdGradientBackground()
            
            birdImage
                .frame(width: BirdSize.splashImage, height: BirdSize.splashImage)
                .padding(.horizontal, BirdSpacing.imageHorizontal)
            
            VStack {
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
                .padding(.top, BirdSpacing.large)
                .padding(.horizontal, BirdSpacing.screenHorizontal)
                
                Spacer()
                
                if state == .idle || state == .requestingPermission || state == .validatingRemoteConfig {
                    BirdButton(
                        title: AppCopy.Splash.Actions.startAdventure,
                        state: (state == .requestingPermission || state == .validatingRemoteConfig) ? .loading : .normal
                    ) {
                        onStartAction()
                    }
                    .padding()
                    .disabled(state != .idle)
                }
            }
            .padding(.horizontal, BirdSpacing.screenHorizontal)
        }
    }
    
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
}

#Preview("Splash – Idle (Initial)") {
    SplashContentView(
        state: .idle,
        onStartAction: { print("Start tapped") }
    )
}

#Preview("Splash – Requesting Permission (Loading)") {
    SplashContentView(
        state: .requestingPermission,
        onStartAction: {}
    )
}

#Preview("Splash – Validating Config (Loading)") {
    SplashContentView(
        state: .validatingRemoteConfig,
        onStartAction: {}
    )
}

#Preview("Splash – Ready to Navigate") {
    SplashContentView(
        state: .readyToNavigate,
        onStartAction: {}
    )
}

#Preview("Splash – Failed (Error)") {
    SplashContentView(
        state: .failed("Unexpected error occurred"),
        onStartAction: {}
    )
}
