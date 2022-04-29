//
//  NotificationCenter+Extension.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 14/04/2022.
//

import Foundation

extension NotificationCenter {
    public static func weatherSettingsChanged() {
        NotificationCenter.default.post(name: LeBaluchonNotification.weatherSettingsChanged, object: nil)
    }
}
