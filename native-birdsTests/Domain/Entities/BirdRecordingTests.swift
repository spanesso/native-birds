//
//  BirdRecordingTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class BirdRecordingTests: XCTestCase {
    
    func test_birdRecording_initialization() {
        let sut = BirdRecording(
            id: "rec_123",
            genus: "Turdus",
            species: "merula",
            commonName: "Blackbird",
            audioUrl: "https://audio.com/123.mp3",
            quality: "A",
            type: "song",
            duration: "45"
        )
        
        XCTAssertEqual(sut.id, "rec_123")
        XCTAssertEqual(sut.duration, "45")
        XCTAssertEqual(sut.quality, "A")
    }
    
    func test_birdRecording_hashable_conformance() {
        let rec1 = BirdRecording(id: "1", genus: "G", species: "S", commonName: "C", audioUrl: "U", quality: "Q", type: "T", duration: "D")
        let rec2 = BirdRecording(id: "1", genus: "G", species: "S", commonName: "C", audioUrl: "U", quality: "Q", type: "T", duration: "D")
        
        XCTAssertEqual(rec1.hashValue, rec2.hashValue)
        XCTAssertEqual(rec1, rec2)
    }
}
