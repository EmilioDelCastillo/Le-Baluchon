//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 29/04/2022.
//

import Foundation

struct CurrencyService {
    private let baseService: BaseService
    
    init(session: URLSession = URLSession.shared) {
        baseService = BaseService(session: session)
    }
    
    /// Returns the current rate, from cache if it isn't older than a day, from the API otherwise.
    /// - Returns: A `Currency` object with up-to-date values.
    public func getCurrentRate(cached: Bool = true) async throws -> Currency {
        // Try to get the rate from disk, if it isn't older than a day.
        if cached, let cachedCurrencyRate = UserDefaults.currencyRate,
           let timestamp = cachedCurrencyRate.timestamp {
            
            let cachedDate = Date(timeIntervalSince1970: Double(timestamp))
            let cachedStartOfDay = Calendar.current.startOfDay(for: cachedDate)
            let currentStartOfDay = Calendar.current.startOfDay(for: Date())
            
            if cachedStartOfDay == currentStartOfDay {
                return cachedCurrencyRate
            }
        }
        
        let url = URLFactory.currency()
        do {
            let currency: Currency = try await baseService.fetchData(from: url)
            guard currency.success else { throw CurrencyServiceError.fetchError }
            UserDefaults.currencyRate = currency
            return currency
        } catch {
            throw error
        }
    }
}
