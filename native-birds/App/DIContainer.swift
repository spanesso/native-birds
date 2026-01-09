//
//  DIContainer.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

@MainActor
final class DIContainer{
    
    let router: AppRouter
    let remoteConfig: RemoteConfigProtocol
    let locationService: LocationServiceProtocol
    
    private init(
        router: AppRouter,
        remoteConfig: RemoteConfigProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.router = router
        self.remoteConfig = remoteConfig
        self.locationService = locationService
    }
    
    static func construct() -> DIContainer {
        let router = AppRouter()
        let remoteConfig = RemoteConfigRepository()
        let locationService = LocationService()
        
        return DIContainer(
            router: router,
            remoteConfig: remoteConfig,
            locationService: locationService
        )
    }
}
