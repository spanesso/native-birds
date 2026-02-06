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
        NavigationStack(path: $router.path) {
            container.makeSplashView()
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .birdList:
                    container.makeBirdsListView()
                case .birdDetail(let bird):
                    container.makeBirdDetailView(bird: bird)
                }
            }
        }
    }
}
