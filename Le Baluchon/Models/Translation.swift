//
//  Translation.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 27/05/2022.
//

import Foundation

struct Translations: Decodable {
    let translations: [Translation]
}

public struct Translation: Decodable {
    public let detectedSourceLanguage: String
    public let text: String
}
