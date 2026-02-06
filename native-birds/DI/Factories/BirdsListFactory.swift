//
//  BirdsListFactory.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

@MainActor
final class BirdsListFactory {
    private let core: CoreDependencies
    private let birds: BirdsDependencies

    init(
        core: CoreDependencies,
        birds: BirdsDependencies
    ) {
        self.core = core
        self.birds = birds
    }

    func makeView() -> some View {
        let viewModel = BirdsListViewModel(
            locationService: core.locationService,
            remoteConfig: core.remoteConfig,
            fetchNearbyBirds: birds.fetchNearbyBirds,
            dataMerger: birds.dataMerger
        )

        return BirdsListView(
            viewModel: viewModel,
            imageCache: birds.imageCache,
            router: core.router
        )
    }
}
