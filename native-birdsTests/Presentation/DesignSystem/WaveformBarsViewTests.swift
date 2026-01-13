//
//  WaveformBarsViewTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class WaveformBarsViewTests: XCTestCase {
    
    func test_waveformBars_handlesEmptySamplesSafely() {
        let sut = WaveformBarsView(samples: [])
        XCTAssertEqual(sut.samples.count, 0)
    }
    
    func test_waveformBars_initialization() {
        let samples: [CGFloat] = [0.1, 0.5, 1.0]
        let sut = WaveformBarsView(samples: samples)
        XCTAssertEqual(sut.samples, samples)
    }
}
