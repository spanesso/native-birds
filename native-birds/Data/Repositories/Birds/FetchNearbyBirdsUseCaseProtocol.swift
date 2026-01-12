//
//  FetchNearbyBirdsUseCaseProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 10/01/26.
//


import Foundation

protocol FetchNearbyBirdsUseCaseProtocol: Sendable {
    func execute(
           lat: Double,
           lng: Double,
           page: Int,
           perPage: Int,
           bearerToken: String
       ) async throws -> PagedResult<Bird>
}
