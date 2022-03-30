//
//  BaseServiceTests.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 15/03/2022.
//

import XCTest
@testable import Le_Baluchon

class BaseServiceTests: XCTestCase {
    private var subject: BaseService!
    private let dummyURL = URL(string: "www.example.com")!
    
    private struct TestType: Decodable {
        var id: Int
        var test: Bool
    }
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        subject = BaseService(session: urlSession)
        
    }
    
    func testBaseServiceThrowsError() async {
        let jsonData = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.dummyURL, statusCode: 20, httpVersion: nil, headerFields: nil)!
            return (response, jsonData)
        }
        
        do {
            let _: TestType = try await self.subject.fetchData(from: dummyURL)
            XCTFail("Didn't throw")
            
        } catch BaseServiceError.networkError {
            // success
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testBaseServiceReturnsData() async {
        let id = 10
        let test = true
        let jsonData = """
        {
            "id": \(id),
            "test": \(test)
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.dummyURL, statusCode: 20, httpVersion: nil, headerFields: nil)!
            return (response, jsonData)
        }
        
        do {
            let result: TestType = try await subject.fetchData(from: dummyURL)
            XCTAssertEqual(result.test, true)
            XCTAssertEqual(result.id, 10)
            
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
    }
}
