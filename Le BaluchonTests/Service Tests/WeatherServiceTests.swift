//
//  WeatherServiceTests.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 15/03/2022.
//

import XCTest
@testable import Le_Baluchon

class WeatherServiceTests: XCTestCase {
    private var subject: WeatherService!
    private var session = MockURLProtocol()
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        subject = WeatherService(session: urlSession)
    }
    
    func testGetWeatherFromCityName() async {
        
        do {
            let weather = try await subject.getWeather(city: "Angers")
            
            XCTAssertEqual(weather.temp, 20)
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
        
    }
}
