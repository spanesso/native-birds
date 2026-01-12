//
//  BirdFixtures.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

@testable import native_birds
import Foundation

enum BirdFixtures {

    static func bird(
        name: String,
        english: String? = nil,
        photo: Bool = false
    ) -> Bird {
        Bird(
            taxonId: Int.random(in: 1...999),
            preferredCommonName: english,
            name: name,
            defaultPhotoUrl: photo ? URL(string: "https://bird_image.jpg") : nil,
            defaultPhotoMediumUrl: nil,
            wikipediaURL: URL(string: "https://wikipedia")!
        )
    }

    static func list() -> [Bird] {
        Bird.mockList()
    }
}
