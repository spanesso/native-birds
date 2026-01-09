//
//  Bird.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation

struct Bird: Hashable, Sendable {
    let taxonId: Int
    let englishCommonName: String?
    let name: String
    let defaultPhotoUrl: URL?
    let defaultPhotoMediumUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case taxonId = "taxon_id"
        case englishCommonName = "english_common_name"
        case name
        case defaultPhotoUrl = "default_photo_url"
        case defaultPhotoMediumUrl = "default_photo_medium_url"
    }
}


extension Bird {
    static func mock() -> Bird {
        Bird(
            taxonId: 1,
            englishCommonName: "Peregrine Falcon",
            name: "Peregrine Falcon",
            defaultPhotoUrl: nil,
            defaultPhotoMediumUrl: nil
        )
    }
    
    static func mockList() -> [Bird] {
        [
            Bird(
                taxonId: 1,
                englishCommonName: "Inca Jay",
                name: "Cyanocorax yncas",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil
            ),
            Bird(
                taxonId: 2,
                englishCommonName: "Great Kiskadee",
                name: "Pitangus sulphuratus",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil
            ),
            Bird(
                taxonId: 3,
                englishCommonName: "Peregrine Falcon",
                name: "Peregrine Falcon",
                defaultPhotoUrl: nil,
                defaultPhotoMediumUrl: nil
            )
        ]
    }
}
