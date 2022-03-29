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
    private let session = MockURLSession()
    private let dummyURLRequest = URLRequest(url: URL(string: "www.example.com")!)
    
    private let testData = """
        {
            "id": 10,
            "test": true
        }
        """.data(using: .utf8)!
    
    private struct TestType: Decodable {
        var id: Int
        var test: Bool
    }
    
    override func setUp() {
        super.setUp()
        subject = BaseService(session: session)
        session.data = testData
    }
    
    func testBaseServiceThrowsError() async {
        session.fail = true
        
        do {
            let _: TestType = try await self.subject.fetchData(from: self.dummyURLRequest)
            XCTFail("Didn't throw")
            
        } catch BaseServiceError.networkError {
            // success
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testBaseServiceReturnsData() async {
        do {
            let result: TestType = try await subject.fetchData(from: dummyURLRequest)
            XCTAssertEqual(result.test, true)
            XCTAssertEqual(result.id, 10)
            
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
    }
}
