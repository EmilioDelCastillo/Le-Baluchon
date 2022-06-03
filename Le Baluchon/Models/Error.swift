//
//  Error.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import Foundation

enum BaluchonError: Error {
    case missingConfig
    case temporaryError
}

enum BaseServiceError: Error {
    case networkError
    case internalError
}

enum WeatherServiceError: Error, Equatable {
    case cityNotFound
    case wrongUrl(url: URL)
}

enum CurrencyServiceError: Error {
    case fetchError
}

enum TranslationServiceError: Error {
    case translationError
}
