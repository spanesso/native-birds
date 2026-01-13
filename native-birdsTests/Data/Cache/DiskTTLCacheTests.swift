//
//  DiskTTLCacheTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class DiskTTLCacheTests: XCTestCase {
    
    private var sut: DiskTTLCache!
    private let fileManager = FileManager.default
    private let testFolderName = "TestDiskCache"
    private let testTTL: TimeInterval = 2
    
    override func setUp() async throws {
        try await super.setUp()
        sut = DiskTTLCache(folderName: testFolderName, ttl: testTTL)
    }
    
    override func tearDown() async throws {
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folderURL = cachesURL.appendingPathComponent(testFolderName)
        try? fileManager.removeItem(at: folderURL)
        sut = nil
        try await super.tearDown()
    }
    
    func test_init_shouldCreateCacheDirectory() async {
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folderURL = cachesURL.appendingPathComponent(testFolderName)
        
        XCTAssertTrue(fileManager.fileExists(atPath: folderURL.path))
    }
    
    func test_fileURL_shouldReturnConsistentPath() async {
        let key = "https://example.com/audio.mp3"
        let ext = "mp3"
        
        let url1 = await sut.fileURL(for: key, fileExtension: ext)
        let url2 = await sut.fileURL(for: key, fileExtension: ext)
        
        XCTAssertEqual(url1, url2)
        XCTAssertTrue(url1.path.contains(testFolderName))
        XCTAssertTrue(url1.path.hasSuffix(".mp3"))
    }
    
    func test_exists_whenFileIsCreated_shouldReturnTrue() async throws {
        let key = "existence_test"
        let url = await sut.fileURL(for: key, fileExtension: "txt")
        let data = "test_content".data(using: .utf8)!
        
        try data.write(to: url)
        
        let exists = await sut.exists(url)
        XCTAssertTrue(exists)
    }
    
    func test_remove_shouldDeleteFileFromDisk() async throws {
        let key = "removal_test"
        let url = await sut.fileURL(for: key, fileExtension: "txt")
        try "content".data(using: .utf8)!.write(to: url)
        
        await sut.remove(url)
        
        XCTAssertFalse(fileManager.fileExists(atPath: url.path))
    }
    
    func test_isFresh_whenWithinTTL_shouldReturnTrue() async throws {
        let key = "freshness_test"
        let url = await sut.fileURL(for: key, fileExtension: "txt")
        try "content".data(using: .utf8)!.write(to: url)
        
        let isFresh = await sut.isFresh(url)
        XCTAssertTrue(isFresh)
    }
    
    func test_isFresh_whenPastTTL_shouldReturnFalse() async throws {
        let key = "expiry_test"
        let url = await sut.fileURL(for: key, fileExtension: "txt")
        try "content".data(using: .utf8)!.write(to: url)
        
        let expiredDate = Date().addingTimeInterval(-testTTL - 10)
        try fileManager.setAttributes([.modificationDate: expiredDate], ofItemAtPath: url.path)
        
        let isFresh = await sut.isFresh(url)
        XCTAssertFalse(isFresh)
    }
    
    func test_removeIfExpired_whenFileIsExpired_shouldDeleteIt() async throws {
        let key = "auto_cleanup_test"
        let url = await sut.fileURL(for: key, fileExtension: "txt")
        try "content".data(using: .utf8)!.write(to: url)
        
        let expiredDate = Date().addingTimeInterval(-testTTL - 10)
        try fileManager.setAttributes([.modificationDate: expiredDate], ofItemAtPath: url.path)
        
        await sut.removeIfExpired(url)
        
        XCTAssertFalse(fileManager.fileExists(atPath: url.path))
    }
    
    func test_touch_shouldUpdateModificationDate() async throws {
        let key = "touch_test"
        let url = await sut.fileURL(for: key, fileExtension: "txt")
        try "content".data(using: .utf8)!.write(to: url)
        
        let pastDate = Date().addingTimeInterval(-100)
        try fileManager.setAttributes([.modificationDate: pastDate], ofItemAtPath: url.path)
        
        await sut.touch(url)
        
        let attributes = try fileManager.attributesOfItem(atPath: url.path)
        let newModificationDate = attributes[.modificationDate] as? Date
        
        XCTAssertNotNil(newModificationDate)
        XCTAssertTrue(newModificationDate! > pastDate)
    }
}
