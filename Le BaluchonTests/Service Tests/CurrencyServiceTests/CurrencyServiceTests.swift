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
    
    func testGetCurrentRateWithCache() async {
        let timeStamp = Int(Date().timeIntervalSince1970)
        let currencyData = """
        {
        "success": true,
        "timestamp": \(timeStamp),
        "base": "EUR",
        "date": "2022-06-02",
        "rates": {"USD": 1.07483, "SMT": 15.111}
        }
        """.data(using: .utf8)!
        
        var isTestingCache = false
        MockURLProtocol.requestHandler = { request in
            
            if isTestingCache {
                XCTFail("This shouldn't be called when getting data from cache.")
            }
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            if response.url == URLFactory.currency() {
                return (response, currencyData)
            }
            XCTFail("Wrong URL: \(response.url!)")
            throw CurrencyServiceError.fetchError
        }
        
        do {
            // First call to set the userDefaults
            let _ = try await subject.getCurrentRate(cached: false)
            
            // Acutal test
            isTestingCache = true
            let currency = try await subject.getCurrentRate()
            
            XCTAssertEqual(currency.success, true)
            XCTAssertEqual(currency.timestamp, timeStamp)
            XCTAssertEqual(currency.convert(from: 1), 1.07483)
            
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
    }
    
    func testGetCurrencyRateWithFailingData() async {
        let currencyData = getData(name: "CurrencyDataFailing")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            if response.url == URLFactory.currency() {
                return (response, currencyData)
            }
            XCTFail("Wrong URL: \(response.url!)")
            throw CurrencyServiceError.fetchError
        }
        
        do {
            let _ = try await subject.getCurrentRate(cached: false)
            XCTFail("An error should have been thrown.")
        } catch {
            XCTAssertEqual(error as! CurrencyServiceError, CurrencyServiceError.fetchError)
        }
    }
}
