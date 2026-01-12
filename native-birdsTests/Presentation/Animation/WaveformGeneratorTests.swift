//
//  WaveformGeneratorTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import AVFoundation
@testable import native_birds

final class WaveformGeneratorTests: XCTestCase {
    
    func test_generate_withInvalidURL_shouldThrowError() async {
        let invalidURL = URL(fileURLWithPath: "/dev/null/invalid.mp3")
        
        do {
            _ = try await WaveformGenerator.generate(from: invalidURL)
            XCTFail("Expected error to be thrown for invalid URL")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_generate_withEmptyFile_shouldReturnEmptyArray() async throws {
        let emptyURL = FileManager.default.temporaryDirectory.appendingPathComponent("empty.m4a")
        try " ".data(using: .utf8)?.write(to: emptyURL)
        
        do {
            _ = try await WaveformGenerator.generate(from: emptyURL)
            XCTFail("Should throw error as it is not a valid audio file")
        } catch {
            XCTAssertNotNil(error)
        }
        
        try? FileManager.default.removeItem(at: emptyURL)
    }
}
