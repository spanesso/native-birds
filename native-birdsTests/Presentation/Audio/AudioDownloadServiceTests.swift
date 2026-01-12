//
//  AudioDownloadServiceTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class AudioDownloadServiceTests: XCTestCase {
    
    private var sut: AudioDownloadService!
    
    override func setUp() {
        super.setUp()
        sut = AudioDownloadService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_download_sanitizesURLWithoutScheme() async {
        let urlWithoutScheme = URL(string: "//xeno-canto.org/sounds/test.mp3")!
        let expectation = expectation(description: "Attempted download with sanitized URL")
        
        Task {
            do {
                _ = try await sut.download(remoteURL: urlWithoutScheme) { _ in }
            } catch {
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }
    
    func test_download_addsCustomUserAgentHeader() async {
        let remoteURL = URL(string: "https://xeno-canto.org/test.mp3")!
        let expectation = expectation(description: "Request contains expected headers")
        
        Task {
            do {
                _ = try await sut.download(remoteURL: remoteURL) { _ in }
            } catch {
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }

    func test_urlSession_didWriteData_calculatesCorrectProgress() {
        let task = URLSessionDownloadTask()
        var reportedProgress: Double = 0
        let onProgress: @Sendable (Double) -> Void = { reportedProgress = $0 }
        
        let remoteURL = URL(string: "https://test.com/audio.mp3")!
        
        Task {
            _ = try? await sut.download(remoteURL: remoteURL, onProgress: onProgress)
        }
        
        sut.urlSession(URLSession.shared, downloadTask: task, didWriteData: 500, totalBytesWritten: 500, totalBytesExpectedToWrite: 1000)
        
        XCTAssertEqual(reportedProgress, 0.5, accuracy: 0.01)
    }
}
