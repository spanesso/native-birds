//
//  DIContainer.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

@MainActor
final class DIContainer{
    
    let router: AppRouter
    let remoteConfig : RemoteConfigRepository
    
    private init(
        router: AppRouter,
        remoteConfig: RemoteConfigRepository) {
        self.router = router
        self.remoteConfig = remoteConfig
    }
    
    static func construct() -> DIContainer {
        let router = AppRouter()
        let remoteConfig = RemoteConfigRepository()
        
        return DIContainer(
            router: router,
            remoteConfig: remoteConfig
        )
    }
}
