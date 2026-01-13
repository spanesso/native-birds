//
//  PagedResultTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class PagedResultTests: XCTestCase {
    
    func test_pagedResult_initialization() {
        let items = ["Bird 1", "Bird 2"]
        let hasMore = true
        
        let sut = PagedResult(items: items, hasMore: hasMore)
        
        XCTAssertEqual(sut.items.count, 2)
        XCTAssertEqual(sut.items, items)
        XCTAssertTrue(sut.hasMore)
    }
}
