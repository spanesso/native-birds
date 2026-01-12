//
//  AppRouterView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI

struct AppRouterView: View {
    
    @ObservedObject var router: AppRouter
    let container: DIContainer
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { router.path },
            set: { router.path = $0 }
        )) {
            SplashView(
                viewModel: SplashViewModel(
                    router: router,
                    remoteConfig: container.remoteConfig,
                    locationService: container.locationService
                )
            ).navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .birdList:
                    BirdsListView(
                        viewModel: BirdsListViewModel(
                            locationService: container.locationService,
                            remoteConfig: container.remoteConfig,
                            fetchNearbyBirds: container.fetchNearbyBirdsUseCase
                        ),
                        imageCache: container.imageCache,
                        router: container.router
                    )
                case .birdDetail(let bird):
                    BirdDetailView(
                        bird: bird,
                        imageCache: container.imageCache,
                        viewModel: BirdDetailViewModel(
                            bird: bird,
                            remoteConfig: container.remoteConfig,
                            fetchRecording: container.fetchBirdRecordingUseCase,
                            audioCache: container.audioCache,
                            downloader: container.audioDownloader
                        ),
                        onBack: {
                            container.router.pop()
                        }
                    )
                }
            }
        }
    }
}
