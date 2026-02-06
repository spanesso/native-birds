//
//  AppRouterView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//
import SwiftUI

struct AppRouterView: View {
    @ObservedObject var router: AppRouter
    let container: AppDIContainer

    var body: some View {
        NavigationStack(path: $router.path) {
            container.splashFactory.makeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                        case .birdList:
                            container.birdsListFactory.makeView()
                        case .birdDetail(let bird):
                            container.birdDetailFactory.makeView(bird: bird)
                    }
                }
        }
    }
}
