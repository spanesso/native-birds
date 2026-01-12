//
//  BirdImageCacheTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import UIKit
@testable import native_birds

final class BirdImageCacheTests: XCTestCase {
    
    private var sut: BirdImageCache!
    private let testURL = URL(string: "https://cdn.test.com/images/bird_01.jpg")!
    private let fileManager = FileManager.default
    
    override func setUp() async throws {
        try await super.setUp()
        sut = BirdImageCache()
        try await clearDiskCache()
    }
    
    override func tearDown() async throws {
        try await clearDiskCache()
        sut = nil
        try await super.tearDown()
    }
    
    func test_image_whenCacheIsEmpty_shouldReturnNil() async {
        let cachedImage = await sut.image(for: testURL)
        XCTAssertNil(cachedImage)
    }
    
    func test_store_shouldRetrieveImageFromMemory() async {
        let originalImage = createTestImage(color: .red)
        
        await sut.store(originalImage, for: testURL)
        let retrievedImage = await sut.image(for: testURL)
        
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage?.size, originalImage.size)
    }
    
    func test_image_shouldPersistToDisk() async {
        let originalImage = createTestImage(color: .blue)
        await sut.store(originalImage, for: testURL)
        
        let newSut = BirdImageCache()
        let retrievedImage = await newSut.image(for: testURL)
        
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage?.size, originalImage.size)
    }
    
    func test_store_withLargeImage_shouldHandleCompression() async {
        let largeImage = createTestImage(color: .green, size: CGSize(width: 2000, height: 2000))
        
        await sut.store(largeImage, for: testURL)
        let retrievedImage = await sut.image(for: testURL)
        
        XCTAssertNotNil(retrievedImage)
    }
    
    func test_image_whenDiskDataIsCorrupted_shouldReturnNil() async {
        let folderURL = try! fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("BirdImages")
        
        try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        let fileURL = folderURL.appendingPathComponent(testURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)! + ".jpg")
        
        let corruptedData = "invalid-image-data".data(using: .utf8)!
        try? corruptedData.write(to: fileURL)
        
        let retrievedImage = await sut.image(for: testURL)
        XCTAssertNil(retrievedImage)
    }

    private func createTestImage(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    private func clearDiskCache() async throws {
        let cacheURL = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("BirdImages")
        
        if fileManager.fileExists(atPath: cacheURL.path) {
            try fileManager.removeItem(at: cacheURL)
        }
    }
}
