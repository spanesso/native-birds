//
//  NetworkClient.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

enum NetworkError: Error, Equatable, Sendable {
    case invalidResponse
    case decoding
    case serverError(Int)
    case unauthorized
    case unknown
    
}

protocol NetworkClient: Sendable {
    
    func data(for request: URLRequest) async throws -> Data
}
