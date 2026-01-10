//
//  FetchNearbyBirdsUseCase.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

protocol FetchNearbyBirdsUseCaseProtocol: Sendable {
    func execute(lat: Double, lng: Double, page: Int, perPage: Int, bearerToken: String) async throws -> BirdsPage
}

struct FetchNearbyBirdsUseCase: FetchNearbyBirdsUseCaseProtocol {
    let repo: BirdsRepositoryProtocol

    func execute(lat: Double, lng: Double, page: Int, perPage: Int, bearerToken: String) async throws -> BirdsPage {
        try await repo.fetchNearbyBirds(
            lat: lat,
            lng: lng,
            page: page,
            perPage: perPage,
            bearerToken: bearerToken
        )
    }
}
