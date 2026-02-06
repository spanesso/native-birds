//
//  AudioDependencies.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//
import Foundation

final class AudioDependencies {
    let xenoRepository: XenoCantoRepositoryProtocol
    let fetchRecording: FetchBirdRecordingUseCaseProtocol
    let audioCache: BirdAudioCacheProtocol
    let downloader: AudioDownloadServiceProtocol

    init(network: NetworkDependencies) {
        self.xenoRepository = XenoCantoRepository(client: network.client)
        self.fetchRecording = FetchBirdRecordingUseCase(repo: xenoRepository)
        self.audioCache = BirdAudioCache()
        self.downloader = AudioDownloadService()
    }
}
