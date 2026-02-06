//
//  native_birdsApp.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI
import FirebaseCore

@main
struct native_birdsApp: App {
    private let container: AppDIContainer
    
    init() {
        FirebaseApp.configure()
        self.container = AppDIContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRouterView(
                router: container.core.router,
                container: container
            )
            .task {
                _ = await container.core.remoteConfig.activate()
            }
        }
    }
}
