//
//  BirdAudioPlayerTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import AVFoundation
@testable import native_birds

@MainActor
final class BirdAudioPlayerTests: XCTestCase {
    
    private var sut: BirdAudioPlayer!
    private let testURL = URL(string: "https://xeno-canto.org/123.mp3")!
    
    override func setUp() {
        super.setUp()
        sut = BirdAudioPlayer()
    }
    
    override func tearDown() {
        sut.stop()
        sut = nil
        super.tearDown()
    }
    
    func test_initialState_isPlayingIsFalse() {
        XCTAssertFalse(sut.isPlaying)
    }
    
    func test_play_setsIsPlayingToTrue() {
        sut.play(url: testURL)
        XCTAssertTrue(sut.isPlaying)
    }
    
    func test_pause_setsIsPlayingToFalse() {
        sut.play(url: testURL)
        sut.pause()
        XCTAssertFalse(sut.isPlaying)
    }
    
    func test_stop_setsIsPlayingToFalse() {
        sut.play(url: testURL)
        sut.stop()
        XCTAssertFalse(sut.isPlaying)
    }
    
    func test_playbackFinished_resetsStateAndTriggersCallback() {
        let expectation = expectation(description: "OnDidFinishPlaying triggered")
        sut.onDidFinishPlaying = {
            expectation.fulfill()
        }
        
        sut.play(url: testURL)
        
        NotificationCenter.default.post(
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(sut.isPlaying)
    }
}
