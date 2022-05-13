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
        let geoData = getData(name: "GeoData")
        let weatherData = getData(name: "WeatherData")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 20, httpVersion: nil, headerFields: nil)!
            if response.url == URLFactory.geo(for: "Angers", limit: 1) {
                return (response, geoData)
            } else if response.url == URLFactory.weather(latitude: 47.4739884, longitude: -0.5515588) {
                return (response, weatherData)
            }
            XCTFail("Wrong url: \(response.url!)")
            throw WeatherServiceError.wrongUrl(url: response.url!)
        }
        
        do {
            let weather = try await subject.getWeather(city: "Angers")
            
            XCTAssertEqual(weather.temp, 9)
            XCTAssertEqual(weather.feelsLike, 9)
            XCTAssertEqual(weather.tempMin, 7)
            XCTAssertEqual(weather.tempMax, 11)
            XCTAssertEqual(weather.pressure, 1023)
            XCTAssertEqual(weather.humidity, 100)
            XCTAssertEqual(weather.windSpeed, 4)
            XCTAssertEqual(weather.cityName, "Angers")
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
        
    }
}
