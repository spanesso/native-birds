//
//  BirdDetailFactory.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//
import SwiftUI

@MainActor
final class BirdDetailFactory {
    private let core: CoreDependencies
    private let birds: BirdsDependencies
    private let audio: AudioDependencies

    init(
        core: CoreDependencies,
        birds: BirdsDependencies,
        audio: AudioDependencies
    ) {
        self.core = core
        self.birds = birds
        self.audio = audio
    }

    func makeView(bird: Bird) -> some View {
        let viewModel = BirdDetailViewModel(
            bird: bird,
            remoteConfig: core.remoteConfig,
            fetchRecording: audio.fetchRecording,
            audioCache: audio.audioCache,
            downloader: audio.downloader
        )

        return BirdDetailView(
            bird: bird,
            imageCache: birds.imageCache,
            onBack: { [weak core] in
                core?.router.pop()
            },
            viewModel: viewModel
        )
    }
}
