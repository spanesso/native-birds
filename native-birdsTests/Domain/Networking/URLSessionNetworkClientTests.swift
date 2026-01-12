//
//  URLSessionNetworkClientTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
@testable import native_birds

final class URLSessionNetworkClientTests: XCTestCase {
    
    private var sut: URLSessionNetworkClient!
    private let testURL = URL(string: "https://api.nativebirds.com/v1/test")!
    
    override func setUp() {
        super.setUp()
        sut = URLSessionNetworkClient()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        sut = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func test_data_whenResponseIs200_returnsData() async throws {
        let expectedData = "{\"status\": \"ok\"}".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: self.testURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, expectedData)
        }
        
        let result = try await sut.data(for: URLRequest(url: testURL))
        
        XCTAssertEqual(result, expectedData)
    }
    
    func test_data_whenResponseIs404_throwsServerError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: self.testURL,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, nil)
        }
        
        do {
            _ = try await sut.data(for: URLRequest(url: testURL))
            XCTFail("Should throw serverError(404)")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError(404))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func test_data_whenResponseIsNotHTTP_throwsInvalidResponse() async {
        MockURLProtocol.requestHandler = { request in
            throw NetworkError.invalidResponse
        }
        
        do {
            _ = try await sut.data(for: URLRequest(url: testURL))
            XCTFail("Should throw invalidResponse")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_data_whenConnectionFails_propagatesError() async {
        let connectionError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        
        MockURLProtocol.requestHandler = { request in
            throw connectionError
        }
        
        do {
            _ = try await sut.data(for: URLRequest(url: testURL))
            XCTFail("Should propagate the connection error")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, NSURLErrorNotConnectedToInternet)
        }
    }
}
