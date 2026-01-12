//
//  BirdsListViewModelTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

@MainActor
final class BirdsListViewModelTests: XCTestCase {
    
    private var locationService: MockLocationServiceTests!
    private var remoteConfig: MockRemoteConfigTests!
    private var fetchUseCase: MockFetchNearbyBirdsUseCaseTests!
    private var sut: BirdsListViewModel!
    
    override func setUp() {
        super.setUp()
        
        locationService = MockLocationServiceTests()
        remoteConfig = MockRemoteConfigTests(token: "valid-token")
        fetchUseCase = MockFetchNearbyBirdsUseCaseTests()
        
        sut = BirdsListViewModel(
            locationService: locationService,
            remoteConfig: remoteConfig,
            fetchNearbyBirds: fetchUseCase
        )
    }
    
    
    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.birds.isEmpty)
    }
    
    func test_loadFirstPage_success_setsLoadedState() async {
        fetchUseCase.result = PagedResult(
            items: BirdFixtures.list(),
            hasMore: true
        )
        
        await sut.loadFirstPage()
        
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.birds.count, 2)
        XCTAssertTrue(sut.canLoadMore)
        XCTAssertEqual(sut.currentPage, 1)
    }
    
    func test_loadFirstPage_emptyResult_setsEmptyState() async {
        fetchUseCase.result = PagedResult(items: [], hasMore: false)
        
        await sut.loadFirstPage()
        
        XCTAssertEqual(sut.state, .empty)
        XCTAssertTrue(sut.birds.isEmpty)
    }
    
    func test_loadNextPage_appendsBirds() async {
        fetchUseCase.result = PagedResult(
            items: BirdFixtures.list(),
            hasMore: true
        )
        
        await sut.loadFirstPage()
        await sut.loadNextPage()
        
        XCTAssertEqual(sut.birds.count, 2)
        XCTAssertEqual(sut.currentPage, 2)
    }
    
    func test_deduplication_keepsBestBird() async {
        let bird1 = BirdFixtures.bird(
            name: "Cyanocorax yncas",
            english: nil,
            photo: false
        )
        
        let bird2 = BirdFixtures.bird(
            name: "Cyanocorax yncas",
            english: "Inca Jay",
            photo: true
        )
        
        fetchUseCase.result = PagedResult(
            items: [bird1, bird2],
            hasMore: false
        )
        
        await sut.loadFirstPage()
        
        XCTAssertEqual(sut.birds.count, 1)
        XCTAssertEqual(sut.birds.first?.preferredCommonName, "Inca Jay")
    }
    
    func test_errorOnFirstPage_setsErrorState() async {
        fetchUseCase.error = AppError.missingINaturalistToken
        
        await sut.loadFirstPage()
        
        if case .error = sut.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected error state")
        }
    }
}

