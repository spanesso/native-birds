//
//  INaturalistDTOs.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

struct INatObservationsResponseDTO: Decodable, Sendable {
    let total_results: Int
    let page: Int
    let per_page: Int
    let results: [INatObservationResultDTO]
}

struct INatObservationResultDTO: Decodable, Sendable {
    let taxon: INatTaxonDTO?
}

struct INatTaxonDTO: Decodable, Sendable {
    let id: Int?
    let name: String?
    let english_common_name: String?
    let default_photo: INatDefaultPhotoDTO?
}

struct INatDefaultPhotoDTO: Decodable, Sendable {
    let url: String?
    let medium_url: String?
    let square_url: String?
}

enum INatMapper {
    static func map(dto: INatTaxonDTO) -> Bird? {
        guard
            let id = dto.id,
            let name = dto.name
        else { return nil }

        let listUrl = dto.default_photo?.url.flatMap(URL.init(string:))
        let mediumUrl = dto.default_photo?.medium_url.flatMap(URL.init(string:))

        return Bird(
            taxonId: id,
            englishCommonName: dto.english_common_name,
            name: name,
            defaultPhotoUrl: listUrl,
            defaultPhotoMediumUrl: mediumUrl
        )
    }
}
