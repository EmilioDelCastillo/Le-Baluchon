//
//  Config.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

/// This struct contains the base elements fetched from the Info.plist file.
fileprivate struct Config {
    static func baseUrl(for type: URLType) -> String {
        guard let baseHosts = Bundle.main.infoDictionary?["BASE_HOSTS"] as? NSDictionary else {
            preconditionFailure("Could not find the requested base url")
        }
        switch type {
        case .weather:
            guard let url = baseHosts["WEATHER"] as? String else { preconditionFailure("Could not find the requested weather base url")}
            return url
            
        case .currency:
            guard let url = baseHosts["CURRENCY"] as? String else { preconditionFailure("Could not find the requested currency base url")}
            return url

        case .translation:
            guard let url = baseHosts["TRANSLATION"] as? String else { preconditionFailure("Could not find the requested translation base url")}
            return url

        }
    }
}

fileprivate enum URLType {
    case weather
    case currency
    case translation
}
/// This struct computes the different urls needed to fetch data from the APIs.
public struct URLFactory {
    
    private(set) var path: String
    private(set) var queryItems = [URLQueryItem]()
    private var urlType: URLType
    
    var url: URL {
        var components = URLComponents()
        components.scheme = urlType == .currency ? "http" : "https"
        components.host = Config.baseUrl(for: urlType)
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
    private init(type: URLType, path: String, queryItems: [URLQueryItem]){
        self.urlType = type
        self.path = path
        self.queryItems = queryItems
    }
}

//MARK: - Weather
extension URLFactory {
    /// Returns the url for retrieving the coordinates from the name of a place.
    /// - Parameters:
    ///   - cityName: The searched name.
    ///   - limit: The number of possible matches.
    /// - Returns: The built url from the given parameters.
    static func geo(for cityName: String, limit: Int) -> URL {
        URLFactory(type: .weather, path: "geo/1.0/direct", queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "appid", value: APIKeys.weather)]).url
    }
    
    /// Returns the url for retriving the weather data from a place.
    /// - Parameters:
    ///   - latitude: The latitude coordinate.
    ///   - longitude: The longitude coordinate.
    /// - Returns: The built url from the given parameters.
    static func weather(latitude: Double, longitude: Double) -> URL {
        URLFactory(type: .weather, path: "data/2.5/weather", queryItems: [
            URLQueryItem(name: "lat", value: latitude.string),
            URLQueryItem(name: "lon", value: longitude.string),
            URLQueryItem(name: "appid", value: APIKeys.weather)]).url
    }
}

//MARK: - Currency
extension URLFactory {
    static func currency() -> URL {
        URLFactory(type: .currency, path: "api/latest", queryItems: [
            URLQueryItem(name: "access_key", value: APIKeys.currency),
            URLQueryItem(name: "symbols", value: "USD")
        ]).url
    }
}

//MARK: - Translation
extension URLFactory {
    /// Creates the url to fetch the translation from the API.
    /// - Parameters:
    ///   - text: The text to translate.
    ///   - source: The source language code. Optional.
    ///   - target: The target language code.
    /// - Returns: The built URL from the given parameters.
    static func translate(text: String, from source: String? = nil, to target: String) -> URL {
        URLFactory(type: .translation, path: "v2/translate", queryItems: [
            URLQueryItem(name: "auth_key", value: APIKeys.translation),
            URLQueryItem(name: "source_lang", value: source),
            URLQueryItem(name: "target_lang", value: target),
            URLQueryItem(name: "text", value: text)
        ]).url
    }
}
