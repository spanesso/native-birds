//
//  Factories.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//
import Foundation

final class BirdsDependencies {
    let repository: BirdsRepositoryProtocol
    let fetchNearbyBirds: FetchNearbyBirdsUseCaseProtocol
    let imageCache: BirdImageCacheProtocol
    let dataMerger: BirdDataMergerProtocol

    init(network: NetworkDependencies) {
        self.repository = BirdsRepository(client: network.client)
        self.fetchNearbyBirds = FetchNearbyBirdsUseCase(repo: repository)
        self.imageCache = BirdImageCache()
        self.dataMerger = BirdDataMerger()
    }
}
