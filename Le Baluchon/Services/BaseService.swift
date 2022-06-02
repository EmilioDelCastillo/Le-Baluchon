//
//  BaseService.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

struct BaseService {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// Fetches data from an url.
    /// The data must be described with the object
    /// - Returns: An object full of data lmao
    public func fetchData<T: Decodable>(from url: URL) async throws -> T {

        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
            
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            throw BaseServiceError.internalError
            
        } catch {
            throw BaseServiceError.networkError
        }
    }
}
