//
//  BirdsPageTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class BirdsPageTests: XCTestCase {
    
    func test_hasMore_returnsTrue_whenTotalResultsIsGreaterThanCalculatedOffset() {
        let sut = BirdsPage(
            birds: [],
            page: 1,
            perPage: 10,
            totalResults: 25
        )
        
        XCTAssertTrue(sut.hasMore)
    }
    
    func test_hasMore_returnsFalse_whenOnLastPage() {
        let sut = BirdsPage(
            birds: [],
            page: 3,
            perPage: 10,
            totalResults: 25
        )
        
        XCTAssertFalse(sut.hasMore)
    }
    
    func test_hasMore_returnsFalse_whenTotalResultsEqualsCalculatedOffset() {
        let sut = BirdsPage(
            birds: [],
            page: 2,
            perPage: 10,
            totalResults: 20
        )
        
        XCTAssertFalse(sut.hasMore)
    }
}
