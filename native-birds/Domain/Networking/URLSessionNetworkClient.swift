//
//  URLSessionNetworkClient.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

struct URLSessionNetworkClient: NetworkClient {
    func data(for request: URLRequest) async throws -> Data {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        
        guard (200...299)
            .contains(http.statusCode) else {
            throw NetworkError.serverError(http.statusCode)
        }
        return data
    }
}
