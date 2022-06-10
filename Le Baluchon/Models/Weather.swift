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

public struct Weather: Decodable {
    
    private let weather: [WeatherItem]
    private let internalTemp: Double
    /// The temperature value according to the UserDefaults setting.
    public var temp: Int {
        get { convertTemperatureToUserUnit(internalTemp) }
    }
    
    private let internalFeelsLike: Double
    public var feelsLike: Int {
        get { convertTemperatureToUserUnit(internalFeelsLike)}
    }
    
    private let internalTempMin: Double
    public var tempMin: Int {
        get { convertTemperatureToUserUnit(internalTempMin) }
    }
    
    private let internalTempMax: Double
    public var tempMax: Int {
        get { convertTemperatureToUserUnit(internalTempMax) }
    }
    
    private let internalWindSpeed: Int
    public var windSpeed: Int {
        get { convertSpeedToUserUnit(internalWindSpeed) }
    }
    
    public let pressure: Int
    public let humidity: Int
    public var cityName: String
    
    private enum OuterKeys: String, CodingKey {
        case main, weather, name, wind
    }
    
    private enum MainKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure
        case humidity
    }
    
    private enum WindKeys: String, CodingKey {
        case speed
    }
    
    public init(from decoder: Decoder) throws {
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
        self.internalWindSpeed = try windContainer.decode(Double.self, forKey: .speed).roundedToInt
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
    
    private func convertSpeedToUserUnit(_ speed: Int) -> Int {
        let input = Measurement(value: Double(speed), unit: UnitSpeed.metersPerSecond)
        let output: Double
        
        let speedUnit = UserDefaults.unitSystem
        switch speedUnit {
        case .Metric:
            output = input.converted(to: .kilometersPerHour).value
        case .Imperial:
            output = input.converted(to: .milesPerHour).value
        }
        return output.roundedToInt
    }
}

private struct WeatherItem: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

public enum TemperatureUnit: String {
    case Celcius
    case Fahrenheit
}

public enum UnitSystem: String {
    case Metric, Imperial
}

public enum DefaultLocation: Codable {
    case current
    case custom(_: String)
    
    private enum CodingKeys: CodingKey {
        case current, custom
    }
    
    private enum PostTypeCodingError: Error {
        case decoding(String)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _ = try? values.decode(String.self, forKey: .current) {
            self = .current
            return
        }
        if let value = try? values.decode(String.self, forKey: .custom) {
            self = .custom(value)
            return
        }
        throw PostTypeCodingError.decoding("Whoops! \(dump(values))")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .current:
            try container.encode("custom", forKey: .current)
        case .custom(let value):
            try container.encode(value, forKey: .custom)
        }
    }
}
