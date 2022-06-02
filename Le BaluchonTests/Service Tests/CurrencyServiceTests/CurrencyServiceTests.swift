//
//  CurrencyService.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 02/06/2022.
//

import XCTest

class CurrencyServiceTests: XCTestCase {

    private var subject: CurrencyService!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        subject = CurrencyService(session: urlSession)
    }
    
    func testGetCurrentRate() async {
        let currencyData = getData(name: "CurrencyData")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            if response.url == URLFactory.currency() {
                return (response, currencyData)
            }
            XCTFail("Wrong URL: \(response.url!)")
            throw CurrencyServiceError.fetchError
        }
        
        do {
            let currency = try await subject.getCurrentRate(cached: false)
            XCTAssertEqual(currency.success, true)
            XCTAssertEqual(currency.timestamp, 1654195144)
            XCTAssertEqual(currency.convert(from: 1), 1.07483)
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
    }

}
