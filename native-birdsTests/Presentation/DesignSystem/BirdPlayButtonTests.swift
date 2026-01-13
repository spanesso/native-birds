//
//  BirdPlayButtonTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdPlayButtonTests: XCTestCase {
    
    func test_playButton_isEnabled_logic() {
        let readyState = BirdAudioUIState.ready(localFileURL: URL(fileURLWithPath: "test"))
        let playingState = BirdAudioUIState.playing(localFileURL: URL(fileURLWithPath: "test"))
        let downloadingState = BirdAudioUIState.downloading(progress: 0.5)
        let idleState = BirdAudioUIState.idle
        
        XCTAssertTrue(isEnabled(for: readyState))
        XCTAssertTrue(isEnabled(for: playingState))
        XCTAssertFalse(isEnabled(for: downloadingState))
        XCTAssertFalse(isEnabled(for: idleState))
    }
    
    private func isEnabled(for state: BirdAudioUIState) -> Bool {
        switch state {
        case .ready, .playing, .paused: return true
        default: return false
        }
    }
}
