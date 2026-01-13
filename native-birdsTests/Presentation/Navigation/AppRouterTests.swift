//
//  AppRouterTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import XCTest
@testable import native_birds

@MainActor
final class AppRouterTests: XCTestCase {
    
    private var sut: AppRouter!
    
    override func setUp() {
        super.setUp()
        sut = AppRouter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_initialPath_isEmpty() {
        XCTAssertTrue(sut.path.isEmpty)
    }
    
    func test_push_addsRouteToPath() {
        let route = AppRoute.birdList
        
        sut.push(route)
        
        XCTAssertEqual(sut.path.count, 1)
        XCTAssertEqual(sut.path.last, route)
    }
    
    func test_push_preventsDuplicateConsecutiveRoutes() {
        let route = AppRoute.birdList
        
        sut.push(route)
        sut.push(route)
        
        XCTAssertEqual(sut.path.count, 1)
    }
    
    func test_push_allowsDifferentConsecutiveRoutes() {
        let bird = Bird.mock()
        let firstRoute = AppRoute.birdList
        let secondRoute = AppRoute.birdDetail(bird: bird)
        
        sut.push(firstRoute)
        sut.push(secondRoute)
        
        XCTAssertEqual(sut.path.count, 2)
        XCTAssertEqual(sut.path.last, secondRoute)
    }
    
    func test_pop_removesLastRouteFromPath() {
        sut.push(.birdList)
        sut.push(.birdDetail(bird: .mock()))
        
        sut.pop()
        
        XCTAssertEqual(sut.path.count, 1)
        XCTAssertEqual(sut.path.last, .birdList)
    }
    
    func test_pop_onEmptyPath_doesNothing() {
        sut.pop()
        
        XCTAssertTrue(sut.path.isEmpty)
    }
}
