//
//  Bird.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation

struct Bird: Hashable, Sendable {
    let taxonId: Int
    let preferredCommonName: String?
    let name: String
    let defaultPhotoUrl: URL?
    let defaultPhotoMediumUrl: URL?
    let wikipediaURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case taxonId = "taxon_id"
        case wikipediaURL = "wikipedia_url"
        case preferredCommonName = "preferred_common_name"
        case name
        case defaultPhotoUrl = "default_photo_url"
        case defaultPhotoMediumUrl = "default_photo_medium_url"
    }
}

extension Bird {
    static func preview(
        english: String = "Great Kiskadee",
        scientific: String = "Pitangus sulphuratus"
    ) -> Bird {
        Bird(
            taxonId: 1,
            preferredCommonName: english,
            name: scientific,
            defaultPhotoUrl: nil,
            defaultPhotoMediumUrl: nil,
            wikipediaURL: nil,
        )
    }
}
