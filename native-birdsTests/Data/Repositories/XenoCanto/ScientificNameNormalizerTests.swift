//
//  Untitled.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class ScientificNameNormalizerTests: XCTestCase {
    
    func test_normalize_withValidTwoPartName_returnsCorrectCasing() {
        let input = "passer DOMESTICUS"
        let result = ScientificNameNormalizer.normalize(input: input)
        
        XCTAssertEqual(result.genus, "Passer")
        XCTAssertEqual(result.species, "domesticus")
    }
    
    func test_normalize_withExtraSpaces_returnsCleanedParts() {
        let input = "   turdus   merula   "
        let result = ScientificNameNormalizer.normalize(input: input)
        
        XCTAssertEqual(result.genus, "Turdus")
        XCTAssertEqual(result.species, "merula")
    }
    
    func test_normalize_withSingleWord_returnsNilValues() {
        let input = "Aquila"
        let result = ScientificNameNormalizer.normalize(input: input)
        
        XCTAssertNil(result.genus)
        XCTAssertNil(result.species)
    }
    
    func test_normalize_withEmptyString_returnsNilValues() {
        let input = ""
        let result = ScientificNameNormalizer.normalize(input: input)
        
        XCTAssertNil(result.genus)
        XCTAssertNil(result.species)
    }
    
    func test_normalize_withMultiPartName_takesFirstTwoParts() {
        let input = "Buteo buteo insularum"
        let result = ScientificNameNormalizer.normalize(input: input)
        
        XCTAssertEqual(result.genus, "Buteo")
        XCTAssertEqual(result.species, "buteo")
    }
}
