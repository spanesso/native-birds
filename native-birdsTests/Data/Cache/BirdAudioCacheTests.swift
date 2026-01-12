//
//  BirdAudioCacheTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class BirdAudioCacheTests: XCTestCase {
    
    private var sut: BirdAudioCache!
    private let fileManager = FileManager.default
    private let testRemoteURL = URL(string: "https://example.com/audio/bird123.mp3")!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = BirdAudioCache()
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_storeDownloadedFile_shouldMoveFileToCacheDestination() async throws {
        let tempURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let dummyData = "audio-content".data(using: .utf8)!
        try dummyData.write(to: tempURL)
        
        let destinationURL = try await sut.storeDownloadedFile(from: tempURL, remoteURL: testRemoteURL)
        
        XCTAssertTrue(fileManager.fileExists(atPath: destinationURL.path))
        XCTAssertFalse(fileManager.fileExists(atPath: tempURL.path))
        XCTAssertTrue(destinationURL.path.contains("BirdAudio"))
        XCTAssertTrue(destinationURL.path.hasSuffix(".mp3"))
        
        try? fileManager.removeItem(at: destinationURL)
    }
    
    func test_fileURL_whenFileDoesNotExist_shouldReturnNil() async {
        let result = await sut.fileURL(for: testRemoteURL)
        
        XCTAssertNil(result)
    }
    
    func test_fileURL_whenFileExists_shouldReturnCorrectURL() async throws {
        let tempURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let dummyData = "audio-content".data(using: .utf8)!
        try dummyData.write(to: tempURL)
        
        let savedURL = try await sut.storeDownloadedFile(from: tempURL, remoteURL: testRemoteURL)
        let resultURL = await sut.fileURL(for: testRemoteURL)
        
        XCTAssertNotNil(resultURL)
        XCTAssertEqual(savedURL, resultURL)
        
        try? fileManager.removeItem(at: savedURL)
    }
    
    func test_storeDownloadedFile_whenFileAlreadyExists_shouldOverwrite() async throws {
        let firstTempURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try "first-data".data(using: .utf8)!.write(to: firstTempURL)
        _ = try await sut.storeDownloadedFile(from: firstTempURL, remoteURL: testRemoteURL)
        
        let secondTempURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let secondData = "updated-data".data(using: .utf8)!
        try secondData.write(to: secondTempURL)
        
        let destinationURL = try await sut.storeDownloadedFile(from: secondTempURL, remoteURL: testRemoteURL)
        let finalData = try Data(contentsOf: destinationURL)
        
        XCTAssertEqual(finalData, secondData)
        
        try? fileManager.removeItem(at: destinationURL)
    }
    
    func test_storeDownloadedFile_withInvalidTempURL_shouldThrowError() async {
        let invalidURL = URL(fileURLWithPath: "/non/existent/path")
        
        do {
            _ = try await sut.storeDownloadedFile(from: invalidURL, remoteURL: testRemoteURL)
            XCTFail("Should throw error for non-existent temp file")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
