//
//  XenoCantoRepositoryProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//
 
import Foundation

protocol  XenoCantoRepositoryProtocol:  Sendable {
    
    func fetchTopRecording(
        genus: String,
        species:  String,
        apiKey: String
    ) async throws -> BirdRecording?
}
