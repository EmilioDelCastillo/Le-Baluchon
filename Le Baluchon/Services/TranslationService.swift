//
//  TranslationService.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 17/05/2022.
//

import Foundation

struct TranslationService {
    private let baseService: BaseService
    
    init (session: URLSession = URLSession.shared) {
        baseService = BaseService(session: session)
    }
    
    /// Asynchronously fetches the translation of a given text.
    /// - Parameters:
    ///   - text: The text to translate.
    ///   - sourceLanguage: The source language code. Optional.
    ///   - targetLanguage: The target language code.
    /// - Returns: A `Translation` object with the translated text.
    public func translate(text: String, from sourceLanguage: String? = nil, to targetLanguage: String) async throws -> Translation {
        do {
            let url = URLFactory.translate(text: text, from: sourceLanguage, to: targetLanguage)
            let translations: Translations = try await baseService.fetchData(from: url)
            return translations.translations[0]
        } catch {
            throw error
        }
    }
}
