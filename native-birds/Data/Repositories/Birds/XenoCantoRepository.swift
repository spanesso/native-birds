//
//  XenoCantoRepository.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//
 
import Foundation

final class XenoCantoRepository: XenoCantoRepositoryProtocol {

    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func fetchTopRecording(genus: String, species: String, apiKey: String) async throws -> BirdRecording? {

        var components = URLComponents(string: "https://xeno-canto.org/api/3/recordings")!

        let queryValue = "gen:\(genus)+sp:\(species)+grp:birds"

        components.queryItems = [
            .init(name: "query", value: queryValue),
            
            .init(name: "per_page", value:  "1"),
            
            .init(name: "key", value:  apiKey)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "application/json", forHTTPHeaderField:  "Accept")

        let data = try await client.data(for: request)

        let decoded: XenoCantoRecordingsResponseDTO
        do {
            decoded = try JSONDecoder()
                .decode(XenoCantoRecordingsResponseDTO.self,
                        from: data)
        } catch {
            throw NetworkError.decoding
        }
        

        guard let first = decoded
            .recordings.first else {
            return nil
        }
        return XenoCantoMapper.map(dto: first)
    }
}
