//
//  FetchNearbyBirdsUseCase.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation


struct FetchNearbyBirdsUseCase: FetchNearbyBirdsUseCaseProtocol {

    let repo: BirdsRepositoryProtocol

    func execute(
        lat: Double,
        lng: Double,
        page: Int,
        perPage: Int,
        bearerToken: String
    ) async throws -> PagedResult<Bird> {

        let pageResult = try await repo.fetchNearbyBirds(
            lat: lat,
            lng: lng,
            page: page,
            perPage: perPage,
            bearerToken: bearerToken
        )

        let birds = pageResult.birds

        let hasMore = (pageResult.page * pageResult.perPage) < pageResult.totalResults

        return PagedResult(
            items: birds,
            hasMore: hasMore
        )
    }
}
