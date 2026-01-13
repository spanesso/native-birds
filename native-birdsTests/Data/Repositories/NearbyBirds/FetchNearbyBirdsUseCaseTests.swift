//
//  FetchNearbyBirdsUseCaseTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class FetchNearbyBirdsUseCaseTests: XCTestCase {
    
    private var sut: FetchNearbyBirdsUseCase!
    private var repoMock: BirdsRepositoryMock!
    
    override func setUp() {
        super.setUp()
        repoMock = BirdsRepositoryMock()
        sut = FetchNearbyBirdsUseCase(repo: repoMock)
    }
    
    override func tearDown() {
        sut = nil
        repoMock = nil
        super.tearDown()
    }
    
    func test_execute_calculatesHasMoreTrue_whenResultsExceedCurrentPage() async throws {
        repoMock.resultToReturn = BirdsPage(
            birds: [stubBird()],
            page: 1,
            perPage: 10,
            totalResults: 25
        )
        
        let result = try await sut.execute(lat: 0, lng: 0, page: 1, perPage: 10, bearerToken: "")
        
        XCTAssertTrue(result.hasMore)
        XCTAssertEqual(result.items.count, 1)
    }
    
    func test_execute_calculatesHasMoreFalse_whenAtLastPage() async throws {
        repoMock.resultToReturn = BirdsPage(
            birds: [stubBird()],
            page: 2,
            perPage: 10,
            totalResults: 20
        )
        
        let result = try await sut.execute(lat: 0, lng: 0, page: 2, perPage: 10, bearerToken: "")
        
        XCTAssertFalse(result.hasMore)
    }
    
    func test_execute_propagatesRepositoryError() async {
        repoMock.errorToThrow = NetworkError.invalidResponse
        
        do {
            _ = try await sut.execute(lat: 0, lng: 0, page: 1, perPage: 10, bearerToken: "")
            XCTFail("Should propagate error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    private func stubBird() -> Bird {
        Bird.mock()
    }
}

final class BirdsRepositoryMock: BirdsRepositoryProtocol, @unchecked Sendable {
    var resultToReturn: BirdsPage?
    var errorToThrow: Error?
    
    func fetchNearbyBirds(lat: Double, lng: Double, page: Int, perPage: Int, bearerToken: String) async throws -> BirdsPage {
        if let error = errorToThrow { throw error }
        return resultToReturn ?? BirdsPage(birds: [], page: 0, perPage: 0, totalResults: 0)
    }
}
