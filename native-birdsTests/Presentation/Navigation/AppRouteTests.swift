//
//  AppRouteTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class AppRouteTests: XCTestCase {
    
    func test_appRoute_equality_isConsistent() {
        let bird = Bird.mock()
        let route1 = AppRoute.birdDetail(bird: bird)
        let route2 = AppRoute.birdDetail(bird: bird)
        let route3 = AppRoute.birdList
        
        XCTAssertEqual(route1, route2)
        XCTAssertNotEqual(route1, route3)
    }
    
    func test_appRoute_hashValue_isConsistent() {
        let bird = Bird.mock()
        let route1 = AppRoute.birdDetail(bird: bird)
        let route2 = AppRoute.birdDetail(bird: bird)
        
        XCTAssertEqual(route1.hashValue, route2.hashValue)
    }
}
