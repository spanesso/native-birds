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
    
    let birdsRepository: BirdsRepositoryProtocol
    let fetchNearbyBirdsUseCase: FetchNearbyBirdsUseCaseProtocol
    let imageCache: BirdImageCacheProtocol
    
    private init(
        router: AppRouter,
        
        remoteConfig: RemoteConfigProtocol,
        locationService: LocationServiceProtocol,
        birdsRepository: BirdsRepositoryProtocol,
        fetchNearbyBirdsUseCase:  FetchNearbyBirdsUseCaseProtocol,
        
        imageCache: BirdImageCacheProtocol
    ) {
        self.router = router
        self.remoteConfig = remoteConfig
        
        self.locationService = locationService
        self.birdsRepository = birdsRepository
        
        self.fetchNearbyBirdsUseCase = fetchNearbyBirdsUseCase
        self.imageCache = imageCache
    }
    
    static func construct() -> DIContainer {
        let router = AppRouter()
       
        let remoteConfig = RemoteConfigRepository()
        let locationService = LocationService()
        
        let client =  URLSessionNetworkClient()
        let birdsRepo = BirdsRepository(client: client)
        
        let useCase = FetchNearbyBirdsUseCase(repo: birdsRepo)
        let cache = BirdImageCache()
        
        return DIContainer(
            router: router,
            remoteConfig: remoteConfig,
            locationService: locationService,
            birdsRepository: birdsRepo,
            fetchNearbyBirdsUseCase: useCase,
            imageCache: cache
        )
    }
}
