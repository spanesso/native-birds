//
//  BirdsRepository.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

final class BirdsRepository: BirdsRepositoryProtocol {

    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func fetchNearbyBirds(
        lat: Double,
        lng: Double,
        page: Int,
        perPage: Int,
        bearerToken: String
    ) async throws -> BirdsPage {

        var components = URLComponents(string: "https://api.inaturalist.org/v1/observations")!
        components.queryItems = [
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lng", value: "\(lng)"),
            .init(name: "radius", value: "10"),
            .init(name: "taxon_id", value: "3"),
            .init(name: "has[]", value: "photos"),
            .init(name: "quality_grade", value: "research"),
            .init(name: "per_page", value: "\(perPage)"),
            .init(name: "page", value: "\(page)")
        ]

        guard let url = components.url else { throw NetworkError.invalidResponse }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let data = try await client.data(for: request)

        let decoded: INatObservationsResponseDTO
        do {
            decoded = try JSONDecoder().decode(INatObservationsResponseDTO.self, from: data)
        } catch {
            throw NetworkError.decoding
        }

        let birds = decoded.results
            .compactMap { $0.taxon }
            .compactMap { INatMapper.map(dto: $0) }

        return BirdsPage(
            birds: birds,
            page: decoded.page,
            perPage: decoded.per_page,
            totalResults: decoded.total_results
        )
    }
}
