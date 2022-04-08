//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation
import CoreLocation

class WeatherService {
    private let baseService: BaseService
    
    init(session: URLSession = URLSession.shared) {
        baseService = BaseService(session: session)
    }
    
    public func getWeather(city: String) async throws -> Weather {
        
        do {
            let location = try await getLocation(from: city)
            let url = URLFactory.weather(latitude: location.lat, longitude: location.lon)
            
            let weather: Weather = try await baseService.fetchData(from: url)
            return weather
            
        } catch {
            throw error
        }
    }
    
    public func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> Weather {
        do {
            let url = URLFactory.weather(latitude: latitude, longitude: longitude)
            
            let weather: Weather = try await baseService.fetchData(from: url)
            return weather
            
        } catch {
            throw error
        }
    }
    
    public func getLocation(from name: String) async throws -> Location {
        
        let url = URLFactory.geo(for: name, limit: 1)
        
        do {
            let location: [Location] = try await baseService.fetchData(from: url)
            if location.isEmpty {
                throw WeatherServiceError.cityNotFound
            }
            return location.first!
            
        } catch {
            throw error
        }
    }
}
