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
    let temp: Int
    let feelsLike: Int
    let tempMin: Int
    let tempMax: Int
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
        self.temp = try mainContainer.decode(Double.self, forKey: .temp).roundedToInt
        self.feelsLike = try mainContainer.decode(Double.self, forKey: .feelsLike).roundedToInt
        self.tempMin = try mainContainer.decode(Double.self, forKey: .tempMin).roundedToInt
        self.tempMax = try mainContainer.decode(Double.self, forKey: .tempMax).roundedToInt
        self.pressure = try mainContainer.decode(Int.self, forKey: .pressure)
        self.humidity = try mainContainer.decode(Int.self, forKey: .humidity)
        self.cityName = try outerContainer.decode(String.self, forKey: .name)
        self.windSpeed = try windContainer.decode(Double.self, forKey: .speed).roundedToInt
    }
    
}

struct WeatherItem: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
