//
//  Weather.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

struct Location: Decodable {
    var name: String?
    var localNames: [String: String]?
    var lat: Double
    var lon: Double
    var country: String?
    var state: String?
}

struct Weather: Decodable {
    
    let weather: [WeatherItem]
    private let internalTemp: Double
    /// The temperature value according to the UserDefaults setting.
    var temp: Int {
        get { convertTemperatureToUserUnit(internalTemp) }
    }
    
    private let internalFeelsLike: Double
    var feelsLike: Int {
        get { convertTemperatureToUserUnit(internalFeelsLike)}
    }
    
    var tempMin: Int {
        get { convertTemperatureToUserUnit(internalTempMin) }
    }
    private let internalTempMin: Double
    
    var tempMax: Int {
        get { convertTemperatureToUserUnit(internalTempMax) }
    }
    private let internalTempMax: Double
    
    let pressure: Int
    let humidity: Int
    let cityName: String
    let windSpeed: Int
    
    enum OuterKeys: String, CodingKey {
        case main, weather, name, wind
    }
    
    enum MainKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure
        case humidity
    }
    
    enum WindKeys: String, CodingKey {
        case speed
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        
        let mainContainer = try outerContainer.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        let windContainer = try outerContainer.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        
        self.weather = try outerContainer.decode([WeatherItem].self, forKey: .weather)
        self.internalTemp = try mainContainer.decode(Double.self, forKey: .temp)
        self.internalFeelsLike = try mainContainer.decode(Double.self, forKey: .feelsLike)
        self.internalTempMin = try mainContainer.decode(Double.self, forKey: .tempMin)
        self.internalTempMax = try mainContainer.decode(Double.self, forKey: .tempMax)
        self.pressure = try mainContainer.decode(Int.self, forKey: .pressure)
        self.humidity = try mainContainer.decode(Int.self, forKey: .humidity)
        self.cityName = try outerContainer.decode(String.self, forKey: .name)
        self.windSpeed = try windContainer.decode(Double.self, forKey: .speed).roundedToInt
    }
    
    private func convertTemperatureToUserUnit(_ temperature: Double) -> Int {
        let input = Measurement(value: temperature, unit: UnitTemperature.kelvin)
        let output: Double
        
        let temperatureUnit = UserDefaults.temperatureUnit
        switch temperatureUnit {
        case .Celcius:
            output = input.converted(to: .celsius).value
            
        case .Fahrenheit:
            output = input.converted(to: .fahrenheit).value
        }
            
        return output.roundedToInt
    }
}

struct WeatherItem: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

enum TemperatureUnit: String {
    case Celcius
    case Fahrenheit
}

enum UnitSystem: String {
    case metric, imperial
}
