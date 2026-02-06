//
//  DIContainer.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI

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
    let dataMerger: BirdDataMergerProtocol
    let splashFlowInteractor: SplashFlowInteractorProtocol
    
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
        audioDownloader: AudioDownloadServiceProtocol,
        dataMerger: BirdDataMergerProtocol,
        splashFlowInteractor: SplashFlowInteractorProtocol
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
        
        self.dataMerger = dataMerger
        self.splashFlowInteractor = splashFlowInteractor
    }
    
    static func construct() -> DIContainer {
        let router = AppRouter()
        
        let remoteConfig = RemoteConfigRepository()
        let locationService = LocationService()
        let splashFlowInteractor = SplashFlowInteractor(
            locationService: locationService,
            remoteConfig: remoteConfig
        )
        
        let client =  URLSessionNetworkClient()
        let birdsRepo = BirdsRepository(client: client)
        
        let useCase = FetchNearbyBirdsUseCase(repo: birdsRepo)
        let cache = BirdImageCache()
        
        let xenoRepo = XenoCantoRepository(client: client)
        let fetchRecording = FetchBirdRecordingUseCase(repo: xenoRepo)
        let audioCache = BirdAudioCache()
        let downloader = AudioDownloadService()
        let birdDataMerger = BirdDataMerger()
        
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
            audioDownloader: downloader,
            dataMerger: birdDataMerger,
            splashFlowInteractor: splashFlowInteractor
        )
    }
}

extension DIContainer {
    
    @MainActor
    func makeSplashView() -> some View {
        let viewModel = SplashViewModel(
            router: router,
            splashFlowInteractor: splashFlowInteractor,
            locationService: locationService
        )
        return SplashView(viewModel: viewModel)
    }

    @MainActor
    func makeBirdsListView() -> some View {
        let viewModel = BirdsListViewModel(
            locationService: locationService,
            remoteConfig: remoteConfig,
            fetchNearbyBirds: fetchNearbyBirdsUseCase,
            dataMerger: dataMerger
        )
        return BirdsListView(
            viewModel: viewModel,
            imageCache: imageCache,
            router: router
        )
    }

    @MainActor
    func makeBirdDetailView(bird: Bird) -> some View {
        let viewModel = BirdDetailViewModel(
            bird: bird,
            remoteConfig: remoteConfig,
            fetchRecording: fetchBirdRecordingUseCase,
            audioCache: audioCache,
            downloader: audioDownloader
        )
        return BirdDetailView(
            bird: bird,
            imageCache: imageCache,
            onBack: { [weak router] in router?.pop() },
            viewModel: viewModel
        )
    }
}
