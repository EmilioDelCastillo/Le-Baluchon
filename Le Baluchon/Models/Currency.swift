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
    private var rates: [String: Double]?
    
    public func convert(from euro: Double) -> Double {
        guard let rates = rates,
              let USDRate = rates["USD"] else { return 0 }
        return euro * USDRate
    }
}
