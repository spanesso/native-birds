//
//  DIContainer.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//
import SwiftUI

@MainActor
final class AppDIContainer {
    let core: CoreDependencies
    let splashFactory: SplashFactory
    let birdsListFactory: BirdsListFactory
    let birdDetailFactory: BirdDetailFactory

    init() {
        let network = NetworkDependencies()
        let core = CoreDependencies()
        let birds = BirdsDependencies(network: network)
        let audio = AudioDependencies(network: network)

        self.core = core
        self.splashFactory = SplashFactory(core: core)
        self.birdsListFactory = BirdsListFactory(core: core, birds: birds)
        self.birdDetailFactory = BirdDetailFactory(core: core,birds: birds,audio: audio)
    }
}
