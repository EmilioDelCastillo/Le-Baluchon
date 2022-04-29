//
//  Notifications.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 14/04/2022.
//

import Foundation

struct LeBaluchonNotification {
    static let weatherSettingsChanged = Notification.Name(rawValue: "com.raahs.app.lebaluchon.weatherSettings")
    static let weatherCityChanged = Notification.Name(rawValue: "com.raahs.app.lebaluchon.weatherCity")
}
