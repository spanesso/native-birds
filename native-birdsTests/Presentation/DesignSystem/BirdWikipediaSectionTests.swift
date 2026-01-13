//
//  BirdWikipediaSectionTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

final class BirdWikipediaSectionTests: XCTestCase {
    
    func test_wikipediaSection_withNilURL_initializes() {
        let sut = BirdWikipediaSection(url: nil)
        XCTAssertNil(sut.url)
    }
    
    func test_wikipediaSection_withValidURL_initializes() {
        let url = URL(string: "https://wikipedia.org")
        let sut = BirdWikipediaSection(url: url)
        XCTAssertEqual(sut.url, url)
    }
}
