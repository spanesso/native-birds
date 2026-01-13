//
//  BirdDetailUIStateTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class BirdDetailUIStateTests: XCTestCase {
    
    func test_birdDetailUIState_equatable() {
        let error1 = BirdDetailUIState.error("Failed")
        let error2 = BirdDetailUIState.error("Failed")
        let loading = BirdDetailUIState.loading
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, loading)
    }
    
    func test_birdAudioUIState_equatable() {
        let url = URL(fileURLWithPath: "path")
        let state1 = BirdAudioUIState.ready(localFileURL: url)
        let state2 = BirdAudioUIState.ready(localFileURL: url)
        let state3 = BirdAudioUIState.downloading(progress: 0.5)
        
        XCTAssertEqual(state1, state2)
        XCTAssertNotEqual(state1, state3)
    }
}
