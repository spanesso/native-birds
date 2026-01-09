//
//  DIContainerTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import XCTest
@testable import native_birds

@MainActor
final class DIContainerTests: XCTestCase {
    
    func test_buildContainSuccessfull(){
        let container = DIContainer.construct()
        
        XCTAssertNotNil(container.router)
        XCTAssertNotNil(container.remoteConfig)
    }
}
