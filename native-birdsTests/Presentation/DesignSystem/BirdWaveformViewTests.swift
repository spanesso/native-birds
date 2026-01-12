//
//  BirdWaveformViewTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdWaveformViewTests: XCTestCase {
    
    func test_birdWaveform_initialization() {
        let samples: [CGFloat] = [0.2, 0.8]
        let state = BirdAudioUIState.ready(localFileURL: URL(fileURLWithPath: "test"))
        
        let sut = BirdWaveformView(audioState: state, waveform: samples)
        
        XCTAssertEqual(sut.waveform, samples)
        XCTAssertEqual(sut.audioState, state)
    }
}
