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

struct Translation: Decodable {
    let detectedSourceLanguage: String
    let text: String
}
