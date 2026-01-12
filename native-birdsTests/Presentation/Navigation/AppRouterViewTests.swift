//
//  AppRouterViewTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SwiftUI
@testable import native_birds

@MainActor
final class AppRouterViewTests: XCTestCase {
    
    func test_routerView_initialization() {
        let router = AppRouter()
        let container = DIContainer.construct()
        
        let sut = AppRouterView(router: router, container: container)
        
        XCTAssertNotNil(sut.router)
        XCTAssertEqual(sut.router.path.count, 0)
    }
}
