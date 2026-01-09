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
    var router : AppRouter!
    
    override func setUp() {
        super.setUp()
        router = AppRouter()
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    func test_pushRoutesToPath(){
        let route = AppRoute.birdList
        
        router.push(route)
        
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.last, .birdList)
    }
    
    func test_pushDuplicatedRouteToPath(){
        let route = AppRoute.birdList
        
        router.push(route)
        
        XCTAssertEqual(router.path.count, 1, "It shouldn't allow duplicating the same route at the top of the stack.") 
    }
    
    func test_popRemoveLastPath(){
        router.push(.birdList)
        router.push(.birdDetail(bird: Bird.mock()))
        
        router.pop()
        
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.last, .birdList)
    }
}
