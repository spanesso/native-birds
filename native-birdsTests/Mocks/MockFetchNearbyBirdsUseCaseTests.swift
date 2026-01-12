//
//  MockFetchNearbyBirdsUseCaseTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

@testable import native_birds

final class MockFetchNearbyBirdsUseCaseTests: FetchNearbyBirdsUseCaseProtocol {

    var result: PagedResult<Bird>?
    var error: Error?

    func execute(
        lat: Double,
        lng: Double,
        page: Int,
        perPage: Int,
        bearerToken: String
    ) async throws -> PagedResult<Bird> {

        if let error { throw error }
        return result ?? PagedResult(items: [], hasMore: false)
    }
}
