//
//  BirdDetailViewModelTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import Combine
@testable import native_birds

@MainActor
final class BirdDetailViewModelTests: XCTestCase {
    
    private var sut: BirdDetailViewModel!
    private var bird: Bird!
    private var remoteConfig: MockRemoteConfig!
    private var fetchRecording: MockFetchRecordingUseCase!
    private var audioCache: MockAudioCache!
    private var downloader: MockAudioDownloadService!
    
    override func setUp() {
        super.setUp()
        bird = Bird.mock()
        remoteConfig = MockRemoteConfig(ready: true)
        fetchRecording = MockFetchRecordingUseCase()
        audioCache = MockAudioCache()
        downloader = MockAudioDownloadService()
        
        sut = BirdDetailViewModel(
            bird: bird,
            remoteConfig: remoteConfig,
            fetchRecording: fetchRecording,
            audioCache: audioCache,
            downloader: downloader
        )
    }
    
    override func tearDown() {
        sut = nil
        bird = nil
        remoteConfig = nil
        fetchRecording = nil
        audioCache = nil
        downloader = nil
        super.tearDown()
    }
    
    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.audioState, .idle)
        XCTAssertTrue(sut.waveform.isEmpty)
    }
    
    func test_load_whenApiKeyIsMissing_setsErrorState() async {
        let emptyConfig = MockRemoteConfig(ready: false)
        sut = BirdDetailViewModel(
            bird: bird,
            remoteConfig: emptyConfig,
            fetchRecording: fetchRecording,
            audioCache: audioCache,
            downloader: downloader
        )
        
        await sut.load()
        
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, "Missing Xeno-canto API key from Remote Config.")
        } else {
            XCTFail("Should have transitioned to error state")
        }
    }
    
    func test_load_whenAudioIsCached_skipsDownload() async {
        let cachedURL = URL(fileURLWithPath: "/cache/audio.mp3")
        audioCache.fileURLToReturn = cachedURL
        fetchRecording.recordingToReturn = .mock()
        
        await sut.load()
        
        XCTAssertEqual(sut.audioState, .ready(localFileURL: cachedURL))
        XCTAssertFalse(downloader.downloadCalled)
    }
    
    func test_load_whenAudioIsNotCached_triggersDownloadAndStoresFile() async {
        fetchRecording.recordingToReturn = .mock()
        audioCache.fileURLToReturn = nil
        let tempURL = URL(fileURLWithPath: "/temp/audio.mp3")
        let storedURL = URL(fileURLWithPath: "/cache/stored.mp3")
        downloader.urlToReturn = tempURL
        audioCache.storedURLToReturn = storedURL
        
        await sut.load()
        
        XCTAssertTrue(downloader.downloadCalled)
        XCTAssertTrue(audioCache.storeCalled)
        XCTAssertEqual(sut.audioState, .ready(localFileURL: storedURL))
    }
    
    func test_togglePlay_whenReady_transitionsToPlaying() {
        let localURL = URL(fileURLWithPath: "test.mp3")
        let player = BirdAudioPlayer()
   
        forceSetAudioState(.ready(localFileURL: localURL))
        
        sut.togglePlay(using: player)
        
        XCTAssertEqual(sut.audioState, .playing(localFileURL: localURL))
    }
    
    func test_handleAudioFinished_resetsPlayingToReady() {
        let localURL = URL(fileURLWithPath: "test.mp3")
        forceSetAudioState(.playing(localFileURL: localURL))
        
        sut.handleAudioFinished()
        
        XCTAssertEqual(sut.audioState, .ready(localFileURL: localURL))
    }
    
    private func forceSetAudioState(_ state: BirdAudioUIState) {
        Task { @MainActor in
        }
    }
}
