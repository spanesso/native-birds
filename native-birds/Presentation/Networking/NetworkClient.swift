//
//  NetworkClient.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

enum NetworkError:Error, Sendable {
    case invalidResponse
    
    case httpStatus( Int)
    
    case decoding
}

protocol NetworkClient: Sendable {
    
    func data(for request: URLRequest) async throws -> Data
}
