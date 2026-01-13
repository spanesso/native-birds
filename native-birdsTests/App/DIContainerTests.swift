//
//  DIContainerTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

@MainActor
final class DIContainerTests: XCTestCase {
    
    private var sut: DIContainer!
    
    override func setUp() {
        super.setUp()
        sut = DIContainer.construct()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_container_construction_isSuccessful() {
        XCTAssertNotNil(sut)
    }
    
    func test_coreInfrastructure_isCorrectlyInjected() {
        XCTAssertNotNil(sut.router)
        XCTAssertNotNil(sut.remoteConfig)
        XCTAssertNotNil(sut.locationService)
    }
    
    func test_birdDomain_isCorrectlyWired() {
        XCTAssertNotNil(sut.birdsRepository)
        XCTAssertNotNil(sut.fetchNearbyBirdsUseCase)
        XCTAssertNotNil(sut.imageCache)
        
        XCTAssertTrue(sut.birdsRepository is BirdsRepository)
        XCTAssertTrue(sut.fetchNearbyBirdsUseCase is FetchNearbyBirdsUseCase)
    }
    
    func test_audioDomain_isCorrectlyWired() {
        XCTAssertNotNil(sut.xenoRepo)
        XCTAssertNotNil(sut.fetchBirdRecordingUseCase)
        XCTAssertNotNil(sut.audioCache)
        XCTAssertNotNil(sut.audioDownloader)
        
        XCTAssertTrue(sut.xenoRepo is XenoCantoRepository)
        XCTAssertTrue(sut.fetchBirdRecordingUseCase is FetchBirdRecordingUseCase)
    }
    
    func test_navigationRouter_isSharedInstance() {
        let firstReference = sut.router
        let secondReference = sut.router
        
        XCTAssertTrue(firstReference === secondReference)
    }
    
    func test_networkingDependencies_useSameClientInstance() {
        let birdsRepo = sut.birdsRepository as? BirdsRepository
        let xenoRepo = sut.xenoRepo as? XenoCantoRepository
        
        XCTAssertNotNil(birdsRepo)
        XCTAssertNotNil(xenoRepo)
    }
}
