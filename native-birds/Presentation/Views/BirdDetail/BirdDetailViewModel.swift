//
//  BirdDetailViewModel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//
 
import Foundation
internal import Combine

@MainActor
final class BirdDetailViewModel: ObservableObject {

    @Published private(set) var state: BirdDetailUIState = .idle
    @Published private(set) var audioState: BirdAudioUIState = .idle
    @Published private(set) var waveform: [CGFloat] = []

    private let bird: Bird
    private let remoteConfig: RemoteConfigProtocol
    private let fetchRecording: FetchBirdRecordingUseCaseProtocol
    private let audioCache: BirdAudioCacheProtocol
    private let downloader: AudioDownloadServiceProtocol

    private var didAppear: Bool = false

    init(
        bird: Bird,
        remoteConfig: RemoteConfigProtocol,
        fetchRecording: FetchBirdRecordingUseCaseProtocol,
        audioCache: BirdAudioCacheProtocol,
        downloader: AudioDownloadServiceProtocol
    ) {
        self.bird = bird
        self.remoteConfig = remoteConfig
        self.fetchRecording = fetchRecording
        self.audioCache = audioCache
        self.downloader = downloader
    }

    func onAppear() {
        guard !didAppear else { return }
        didAppear = true

        Task { await load() }
    }

    func load() async {
        state = .loading
        audioState = .idle
        waveform = []

        do {
            let keys = await remoteConfig.getAPIKeys()
            let apiKey = (keys.xenoToken ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

            guard !apiKey.isEmpty else {
                state = .error(BirdDetail.BirdDetailViewCopy.errorAPIKey)
                return
            }

            let recording = try await fetchRecording.execute(
                scientificName: bird.name,
                apiKey: apiKey
            )

            state = .loaded(recording: recording)

            guard let recording,
                  let remote = URL(string: recording.audioUrl) else {
                audioState = .error(BirdDetail.BirdDetailViewCopy.errorAudio)
                return
            }

            if let cached = await audioCache.fileURL(for: remote) {
                audioState = .ready(localFileURL: cached)
                waveform = (try? await WaveformGenerator.generate(from: cached)) ?? []
                return
            }

            audioState = .downloading(progress: 0)

            let tempURL = try await downloader.download(remoteURL: remote) { [weak self] progress in
                Task { @MainActor in
                    self?.audioState = .downloading(progress: min(max(progress, 0), 1))
                }
            }

            let stored = try await audioCache.storeDownloadedFile(from: tempURL, remoteURL: remote)
            audioState = .ready(localFileURL: stored)
            waveform = (try? await WaveformGenerator.generate(from: stored)) ?? []

        } catch {
            state = .error(error.localizedDescription)
            audioState = .error(error.localizedDescription)
        }
    }
    
    func togglePlay(using player: BirdAudioPlayer) {
        switch audioState {

        case .ready(let url):
            try? player.load(localURL: url)
            player.play()
            audioState = .playing(localFileURL: url)

        case .playing(let url):
            player.pause()
            audioState = .paused(localFileURL: url)

        case .paused(let url):
            player.play()
            audioState = .playing(localFileURL: url)

        default:
            break
        }
    }

}
