//
//  BirdTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class BirdTests: XCTestCase {
    
    func test_bird_initialization() {
        let taxonId = 42
        let name = "Cyanocorax yncas"
        let preferredName = "Inca Jay"
        let wikiURL = URL(string: "https://en.wikipedia.org/wiki/Inca_jay")
        
        let sut = Bird(
            taxonId: taxonId,
            preferredCommonName: preferredName,
            name: name,
            defaultPhotoUrl: nil,
            defaultPhotoMediumUrl: nil,
            wikipediaURL: wikiURL
        )
        
        XCTAssertEqual(sut.taxonId, taxonId)
        XCTAssertEqual(sut.name, name)
        XCTAssertEqual(sut.preferredCommonName, preferredName)
        XCTAssertEqual(sut.wikipediaURL, wikiURL)
    }
    
    func test_bird_preview_factory() {
        let englishName = "Falcon"
        let scientificName = "Falco"
        
        let sut = Bird.preview(english: englishName, scientific: scientificName)
        
        XCTAssertEqual(sut.preferredCommonName, englishName)
        XCTAssertEqual(sut.name, scientificName)
        XCTAssertNil(sut.defaultPhotoUrl)
    }
    
    func test_bird_mock_list_count() {
        let birds = Bird.mockList()
        XCTAssertEqual(birds.count, 3)
        XCTAssertEqual(birds.first?.taxonId, 1)
    }
}
