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
        static let defaultLocation = "defaultLocation"
        static let currency = "currency"
    }
    
    public class var temperatureUnit: TemperatureUnit {
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
    
    public class var unitSystem: UnitSystem {
        get {
            if let string = UserDefaults.standard.string(forKey: Keys.unitSystem) {
                return UnitSystem(rawValue: string) ?? .Metric
            }
            return .Metric
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.unitSystem)
        }
    }
    
    public class var defaultLocation: DefaultLocation {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.defaultLocation) {
                let decoder = PropertyListDecoder()
                let result = try? decoder.decode(DefaultLocation.self, from: data)
                return result ?? .current
            }
            return .current
        }
        set {
            let encoder = PropertyListEncoder()
            let data = try! encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: Keys.defaultLocation)
        }
    }
    
    public class var currencyRate: Currency? {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.currency) {
                let decoder = PropertyListDecoder()
                let result = try? decoder.decode(Currency.self, from: data)
                return result
            }
            return nil
        }
        set {
            guard let unwrappedValue = newValue else {
                return
            }
            let encoder = PropertyListEncoder()
            let data = try! encoder.encode(unwrappedValue)
            UserDefaults.standard.set(data, forKey: Keys.currency)
        }
    }
}
