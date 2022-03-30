//
//  BaseService.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

struct BaseService {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession(configuration: .default )) {
        self.session = session
    }
    
    /// Fetches data from an url.
    /// The data must be described with the object
    /// - Returns: An object full of data lmao
    public func fetchData<T: Decodable>(from url: URLRequest) async throws -> T {

        do {
            let (data, _) = try await session.data(for: url, delegate: nil)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
            
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            throw BaseServiceError.internalError
            
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw BaseServiceError.internalError
            
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw BaseServiceError.internalError
            
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw BaseServiceError.internalError
            
        } catch {
            throw BaseServiceError.networkError
        }
    }
}
