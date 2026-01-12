//
//  FetchBirdRecordingUseCase.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

struct FetchBirdRecordingUseCase: FetchBirdRecordingUseCaseProtocol {

    let repo: XenoCantoRepositoryProtocol

    
    func execute(scientificName: String, apiKey: String) async throws -> BirdRecording? {
        let normalized = ScientificNameNormalizer.normalize(scientificName)
        
        guard let genus = normalized.genus,
                let species = normalized.species else {
            return nil
        }

        return try await repo.fetchTopRecording(
            genus: genus,
            species: species,
            apiKey: apiKey
        )
    }
}

enum ScientificNameNormalizer {
    
    static func normalize(_ input: String) -> (genus: String?, species: String?) {
        
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let parts = trimmed.split(whereSeparator: {
            
            $0.isWhitespace }
        ).map(String.init)
        
        guard parts.count >= 2 else {
            return (nil, nil)
        }

        let rawGenus = parts[0]
        let rawSpecies = parts[1]

        let genus = rawGenus.prefix(1).uppercased() + rawGenus.dropFirst().lowercased()
        let species = rawSpecies.lowercased()

        return (genus, species)
    }
}
