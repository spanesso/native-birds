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
    
    let xenoRepo: XenoCantoRepositoryProtocol
    let fetchBirdRecordingUseCase: FetchBirdRecordingUseCaseProtocol
    let audioCache: BirdAudioCacheProtocol
    let audioDownloader: AudioDownloadServiceProtocol
    
    private init(
        router: AppRouter,
        
        remoteConfig: RemoteConfigProtocol,
        locationService: LocationServiceProtocol,
        birdsRepository: BirdsRepositoryProtocol,
        fetchNearbyBirdsUseCase:  FetchNearbyBirdsUseCaseProtocol,
        
        imageCache: BirdImageCacheProtocol,
        
        xenoRepo: XenoCantoRepositoryProtocol,
        fetchBirdRecordingUseCase: FetchBirdRecordingUseCaseProtocol,
        audioCache: BirdAudioCacheProtocol,
        audioDownloader: AudioDownloadServiceProtocol
    ) {
        self.router = router
        self.remoteConfig = remoteConfig
        
        self.locationService = locationService
        self.birdsRepository = birdsRepository
        
        self.fetchNearbyBirdsUseCase = fetchNearbyBirdsUseCase
        self.imageCache = imageCache
        
        
        self.xenoRepo = xenoRepo
        self.fetchBirdRecordingUseCase = fetchBirdRecordingUseCase
        self.audioCache = audioCache
        self.audioDownloader = audioDownloader
    }
    
    static func construct() -> DIContainer {
        let router = AppRouter()
        
        let remoteConfig = RemoteConfigRepository()
        let locationService = LocationService()
        
        let client =  URLSessionNetworkClient()
        let birdsRepo = BirdsRepository(client: client)
        
        let useCase = FetchNearbyBirdsUseCase(repo: birdsRepo)
        let cache = BirdImageCache()
        
        let xenoRepo = XenoCantoRepository(client: client)
        let fetchRecording = FetchBirdRecordingUseCase(repo: xenoRepo)
        let audioCache = BirdAudioCache()
        let downloader = AudioDownloadService()
        
        return DIContainer(
            router: router,
            remoteConfig: remoteConfig,
            locationService: locationService,
            birdsRepository: birdsRepo,
            fetchNearbyBirdsUseCase: useCase,
            imageCache: cache,
            xenoRepo: xenoRepo,
            fetchBirdRecordingUseCase: fetchRecording,
            audioCache: audioCache,
            audioDownloader: downloader
        )
    }
}
