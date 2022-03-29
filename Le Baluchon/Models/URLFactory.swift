//
//  Config.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation


/// This struct contains the base elements fetched from the Info.plist file.
fileprivate struct Config {
    /// The base host, retrieved from Info.plist.
    static var baseUrl: String {
        guard let url = Bundle.main.infoDictionary?["BASE_HOST"] as? String else {
            preconditionFailure("Could not find the requested base url")
        }
        return url
    }
    
}

/// This struct computes the different urls needed to fetch data from the APIs.
public struct URLFactory {
    private static let API_KEY = "c74f9b5c951acb64e5a0068b10c14769"
    
    private(set) var path: String
    private(set) var queryItems = [URLQueryItem]()
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Config.baseUrl
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
    
    // Prevent creation of "free" endpoints
    private init(path: String, queryItems: [URLQueryItem]){
        self.path = path
        self.queryItems = queryItems
    }
    
    /// Returns the url for retrieving the coordinates from the name of a place.
    /// - Parameters:
    ///   - cityName: The searched name.
    ///   - limit: The number of possible matches.
    /// - Returns: The built url from the given parameters.
    static func geo(for cityName: String, limit: Int) -> URL {
        URLFactory(path: "geo/1.0/direct", queryItems: [URLQueryItem(name: "q", value: cityName),
                                                        URLQueryItem(name: "limit", value: String(limit)),
                                                        URLQueryItem(name: "appid", value: API_KEY)]).url
    }
    
    /// Returns the url for retriving the weather data from a place.
    /// - Parameters:
    ///   - latitude: The latitude coordinate.
    ///   - longitude: The longitude coordinate.
    /// - Returns: The built url from the given parameters.
    static func weather(latitude: Double, longitude: Double) -> URL {
        URLFactory(path: "data/2.5/weather", queryItems: [URLQueryItem(name: "lat", value: latitude.string),
                                                          URLQueryItem(name: "lon", value: longitude.string),
                                                          URLQueryItem(name: "appid", value: API_KEY),
                                                          URLQueryItem(name: "units", value: "metric")]).url
    }
}
