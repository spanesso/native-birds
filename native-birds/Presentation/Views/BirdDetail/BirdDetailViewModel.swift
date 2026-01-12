//
//  BirdDetailViewModel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//


import Foundation

@MainActor
final class BirdDetailViewModel: ObservableObject {
    
    @Published private(set) var state: BirdDetailUIState = .idle
    @Published private(set) var audioState: BirdAudioUIState = .idle
    
    
    private let bird: Bird
    private let remoteConfig: RemoteConfigProtocol
    
    private let fetchRecording: FetchBirdRecordingUseCaseProtocol
    private let audioCache: BirdAudioCacheProtocol
    
    private let downloader: AudioDownloadServiceProtocol
    
    private var currentRecording: BirdRecording?
    
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
    }
    
    
}
