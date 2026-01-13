//
//  XenoCantoRepositoryTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class XenoCantoRepositoryTests: XCTestCase {
    
    private var sut: XenoCantoRepository!
    private var clientMock: NetworkClientMock!
    
    override func setUp() {
        super.setUp()
        clientMock = NetworkClientMock()
        sut = XenoCantoRepository(client: clientMock)
    }
    
    override func tearDown() {
        sut = nil
        clientMock = nil
        super.tearDown()
    }
    
    func test_fetchTopRecording_generatesCorrectURLAndQuery() async throws {
        clientMock.dataToReturn = stubValidJSONResponse()
        
        _ = try await sut.fetchTopRecording(genus: "Carduelis", species: "carduelis", apiKey: "secret")
        
        let request = clientMock.lastRequest
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.host, "xeno-canto.org")
        XCTAssertEqual(request?.url?.path, "/api/3/recordings")
        
        let urlString = request?.url?.absoluteString ?? ""
        XCTAssertTrue(urlString.contains("query=gen:Carduelis+sp:carduelis+grp:birds"))
        XCTAssertTrue(urlString.contains("key=secret"))
    }
    
    func test_fetchTopRecording_whenAPIResultIsEmpty_returnsNil() async throws {
        clientMock.dataToReturn = #"{"recordings": []}"#.data(using: .utf8)
        
        let result = try await sut.fetchTopRecording(genus: "Empty", species: "bird", apiKey: "key")
        
        XCTAssertNil(result)
    }
    
    func test_fetchTopRecording_whenResponseIsInvalid_throwsDecodingError() async {
        clientMock.dataToReturn = "invalid_json".data(using: .utf8)
        
        do {
            _ = try await sut.fetchTopRecording(genus: "Fail", species: "bird", apiKey: "key")
            XCTFail("Decoding error expected")
        } catch {
            XCTAssertEqual(error as? NetworkError, .decoding)
        }
    }
    
    private func stubValidJSONResponse() -> Data {
        let json = """
        {
            "recordings": [
                {
                    "id": "123",
                    "gen": "Carduelis",
                    "sp": "carduelis",
                    "en": "European Goldfinch",
                    "file": "https://xeno-canto.org/123/download"
                }
            ]
        }
        """
        return json.data(using: .utf8)!
    }
}

final class NetworkClientMock: NetworkClient, @unchecked Sendable {
    var lastRequest: URLRequest?
    var dataToReturn: Data?
    var errorToThrow: Error?
    
    func data(for request: URLRequest) async throws -> Data {
        lastRequest = request
        if let error = errorToThrow { throw error }
        return dataToReturn ?? Data()
    }
}
