//
//  FetchBirdRecordingUseCaseTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class FetchBirdRecordingUseCaseTests: XCTestCase {
    
    private var sut: FetchBirdRecordingUseCase!
    private var repoMock: XenoCantoRepositoryMock!
    
    override func setUp() {
        super.setUp()
        repoMock = XenoCantoRepositoryMock()
        sut = FetchBirdRecordingUseCase(repo: repoMock)
    }
    
    override func tearDown() {
        sut = nil
        repoMock = nil
        super.tearDown()
    }
    
    func test_execute_whenScientificNameIsInvalid_returnsNilWithoutCallingRepo() async throws {
        let result = try await sut.execute(scientificName: "InvalidName", apiKey: "test_key")
        
        XCTAssertNil(result)
        XCTAssertFalse(repoMock.fetchTopRecordingCalled)
    }
    
    func test_execute_whenNormalizationSucceeds_callsRepoWithCorrectParams() async throws {
        let name = "Zenaida macroura"
        let key = "secure_api_key"
        
        _ = try await sut.execute(scientificName: name, apiKey: key)
        
        XCTAssertTrue(repoMock.fetchTopRecordingCalled)
        XCTAssertEqual(repoMock.lastGenus, "Zenaida")
        XCTAssertEqual(repoMock.lastSpecies, "macroura")
        XCTAssertEqual(repoMock.lastKey, key)
    }
    
    func test_execute_whenRepoThrows_propagatesError() async {
        repoMock.errorToThrow = NetworkError.invalidResponse
        
        do {
            _ = try await sut.execute(scientificName: "Turus merula", apiKey: "key")
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}

final class XenoCantoRepositoryMock: XenoCantoRepositoryProtocol, @unchecked Sendable {
    var fetchTopRecordingCalled = false
    var lastGenus: String?
    var lastSpecies: String?
    var lastKey: String?
    var resultToReturn: BirdRecording?
    var errorToThrow: Error?
    
    func fetchTopRecording(genus: String, species: String, apiKey: String) async throws -> BirdRecording? {
        fetchTopRecordingCalled = true
        lastGenus = genus
        lastSpecies = species
        lastKey = apiKey
        
        if let error = errorToThrow { throw error }
        return resultToReturn
    }
}
