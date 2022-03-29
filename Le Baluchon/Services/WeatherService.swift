//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

class WeatherService {
    private let session: URLSessionProtocol!
    private let baseService: BaseService!
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        baseService = BaseService(session: session)
    }
    
    public func getWeather(city: String) async throws -> Weather {
        
        do {
            let location = try await getLocation(from: city)
            let request = URLRequest(url: URLFactory.weather(latitude: location.lat, longitude: location.lon))
            
            let weather: Weather = try await baseService.fetchData(from: request)
            return weather
            
        } catch {
            throw error
        }
    }
    
    private func getLocation(from name: String) async throws -> Location {
        
        let request = URLRequest(url: URLFactory.geo(for: name, limit: 1))
        
        do {
            let location: [Location] = try await baseService.fetchData(from: request)
            if location.isEmpty {
                throw WeatherServiceError.cityNotFound
            }
            return location.first!
            
        } catch {
            throw error
        }
    }
}
