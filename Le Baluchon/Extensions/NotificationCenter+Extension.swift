//
//  NotificationCenter+Extension.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 14/04/2022.
//

import Foundation

extension NotificationCenter {
    static func temperatureUnitChanged() {
        NotificationCenter.default.post(name: LeBaluchonNotification.temperatureUnitChanged, object: nil)
    }
}
