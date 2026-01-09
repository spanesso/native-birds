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
                    BirdsListView( )
                case .birdDetail(let bird):
                    BirdsListView( )
                }
            }
        }
    }
}
