//
//  BirdRemoteImageTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import UIKit
@testable import native_birds

final class BirdRemoteImageTests: XCTestCase {
    
    private var mockCache: MockImageCache!
    
    override func setUp() {
        super.setUp()
        mockCache = MockImageCache()
    }
    
    func test_remoteImage_initialization_withNilURL() {
        let sut = BirdRemoteImage(url: nil, cache: mockCache)
        XCTAssertNil(sut.url)
    }
    
    func test_remoteImage_hugeImage_flag_isSet() {
        let sut = BirdRemoteImage(url: URL(string: "https://test.com"), hugeImage: true, cache: mockCache)
        XCTAssertTrue(sut.hugeImage)
    }
    
    func test_heroImage_wrapsRemoteImageCorrectly() {
        let testURL = URL(string: "https://test.com/hero.jpg")
        let sut = BirdHeroImage(url: testURL, cache: mockCache)
        
        XCTAssertEqual(sut.url, testURL)
    }
}
