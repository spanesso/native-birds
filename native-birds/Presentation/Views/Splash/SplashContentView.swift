//
//  SplashContentView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

protocol SplashViewDelegate {
    func onStartAdventure()
}

struct SplashContentView: View {
    let state: SplashViewState
    let delegate: SplashViewDelegate
    
    var body: some View {
        ZStack {
            BirdGradientBackground()
            
            birdImage
                .frame(
                    width: BirdSize.splashImage,
                    height: BirdSize.splashImage)
                .padding(.horizontal, BirdSpacing.imageHorizontal)
            
            VStack {
                renderLabels()
                
                Spacer()
                
                if shouldShowButton {
                    BirdButton(
                        title: AppCopy.Splash.Actions.startAdventure,
                        state: isLoading ? .loading : .normal
                    ) {
                        delegate.onStartAdventure()
                    }
                    .padding()
                    .disabled(state != .idle)
                }
            }
            .padding(.horizontal, BirdSpacing.screenHorizontal)
        }
    }
    
    private var isLoading: Bool {
        state == .requestingPermission || state == .validatingRemoteConfig
    }
    
    private var shouldShowButton: Bool {
        state == .idle || state == .requestingPermission || state == .validatingRemoteConfig
    }
    
    @ViewBuilder
    private func renderLabels() -> some View {
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
        delegate: SplashDelegateMock()
    )
}

#Preview("Splash – Requesting Permission (Loading)") {
    SplashContentView(
        state: .requestingPermission,
        delegate: SplashDelegateMock()
    )
}

#Preview("Splash – Validating Config (Loading)") {
    SplashContentView(
        state: .validatingRemoteConfig,
        delegate: SplashDelegateMock()
    )
}

#Preview("Splash – Ready to Navigate") {
    SplashContentView(
        state: .readyToNavigate,
        delegate: SplashDelegateMock()
    )
}

#Preview("Splash – Failed (Error)") {
    SplashContentView(
        state: .failed("Unexpected error occurred"),
        delegate: SplashDelegateMock()
    )
}
