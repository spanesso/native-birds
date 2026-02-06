//
//  SplashFactory.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//
import SwiftUI

@MainActor
final class SplashFactory {
    private let core: CoreDependencies

    init(core: CoreDependencies) {
        self.core = core
    }

    func makeView() -> some View {
        let interactor = SplashFlowInteractor(
            locationService: core.locationService,
            remoteConfig: core.remoteConfig
        )

        let viewModel = SplashViewModel(
            router: core.router,
            splashFlowInteractor: interactor,
            locationService: core.locationService
        )

        return SplashView(viewModel: viewModel)
    }
}
