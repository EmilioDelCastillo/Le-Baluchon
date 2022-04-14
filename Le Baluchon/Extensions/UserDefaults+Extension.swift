//
//  UserDefaults+Extension.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 14/04/2022.
//

import Foundation
extension UserDefaults {
    private enum Keys {
        static let temperatureUnit = "temperatureUnit"
        static let unitSystem = "unitSystem"
    }
    
    class var temperatureUnit: TemperatureUnit {
        get {
            if let string = UserDefaults.standard.string(forKey: Keys.temperatureUnit)  {
                return TemperatureUnit(rawValue: string) ?? .Celcius
            }
            return .Celcius
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.temperatureUnit)
        }
    }
    
    class var unitSystem: UnitSystem {
        get {
            if let string = UserDefaults.standard.string(forKey: Keys.unitSystem) {
                return UnitSystem(rawValue: string) ?? .metric
            }
            return .metric
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.unitSystem)
        }
    }
}
