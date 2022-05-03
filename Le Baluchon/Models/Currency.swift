//
//  Currency.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 03/05/2022.
//

import Foundation

public struct Currency: Codable {
    var success: Bool
    var timestamp: Int?
    var date: String?
    var rates: [String: Double]?
}
