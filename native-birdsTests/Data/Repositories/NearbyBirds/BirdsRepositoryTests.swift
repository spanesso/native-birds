//
//  BirdsRepositoryTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class BirdsRepositoryTests: XCTestCase {
    
    private var sut: BirdsRepository!
    private var clientMock: NetworkClientMock!
    
    override func setUp() {
        super.setUp()
        clientMock = NetworkClientMock()
        sut = BirdsRepository(client: clientMock)
    }
    
    override func tearDown() {
        sut = nil
        clientMock = nil
        super.tearDown()
    }
    
    func test_fetchNearbyBirds_buildsRequestCorrectly() async throws {
        let lat = 4.7110
        let lng = -74.0721
        let page = 1
        let perPage = 20
        let token = "test_bearer_token"
        
        clientMock.dataToReturn = stubValidResponse()
        
        _ = try await sut.fetchNearbyBirds(
            lat: lat,
            lng: lng,
            page: page,
            perPage: perPage,
            bearerToken: token
        )
        
        let request = clientMock.lastRequest
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        let urlString = request?.url?.absoluteString ?? ""
        XCTAssertTrue(urlString.contains("lat=\(lat)"))
        XCTAssertTrue(urlString.contains("lng=\(lng)"))
        XCTAssertTrue(urlString.contains("page=\(page)"))
        XCTAssertTrue(urlString.contains("per_page=\(perPage)"))
        XCTAssertTrue(urlString.contains("taxon_id=3"))
    }
    
    func test_fetchNearbyBirds_throwsDecodingError_onInvalidJSON() async {
        clientMock.dataToReturn = "invalid_json".data(using: .utf8)
        
        do {
            _ = try await sut.fetchNearbyBirds(lat: 0, lng: 0, page: 1, perPage: 10, bearerToken: "")
            XCTFail("Should throw decoding error")
        } catch {
            XCTAssertEqual(error as? NetworkError, .decoding)
        }
    }
    
    func test_fetchNearbyBirds_returnsMappedBirdsPage() async throws {
        clientMock.dataToReturn = stubValidResponse()
        
        let result = try await sut.fetchNearbyBirds(lat: 0, lng: 0, page: 1, perPage: 2, bearerToken: "")
        
        XCTAssertEqual(result.birds.count, 1)
        XCTAssertEqual(result.totalResults, 100)
        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.perPage, 2)
    }
    
    private func stubValidResponse() -> Data {
        let json = """
        {
            "total_results": 100,
            "page": 1,
            "per_page": 2,
            "results": [
                {
                    "taxon": {
                        "id": 1,
                        "name": "Turdus merula",
                        "preferred_common_name": "Common Blackbird",
                        "default_photo": { "medium_url": "https://image.com" }
                    }
                }
            ]
        }
        """
        return json.data(using: .utf8)!
    }
}
