//
//  WeatherViewController+Delegates.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 08/04/2022.
//

import UIKit
import CoreLocation

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Prevent the module from being updated while it's being edited.
        guard isEditingCity == false else { return }
        
        let location = locations.last!
        let currentLocation = Location(name: "",
                            lat: location.coordinate.latitude,
                            lon: location.coordinate.longitude,
                            country: "")
        loadAndSetWeather(for: currentLocation, in: weatherModuleBottom)
    }
}

extension WeatherViewController: WeatherModuleDelegete {
    func didOpenSettings() {
        let viewControllerToPresent = storyboard!.instantiateViewController(withIdentifier: "weatherSettings")
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        present(viewControllerToPresent, animated: true)
    }
    
    func didChangeCityName(to city: String) {
        UserDefaults.defaultLocation = city.isEmpty ? .current : .custom(city)
        NotificationCenter.weatherCityChanged()
    }
    
    func didBeginEditing(_ sender: UITextField) {
        isEditingCity = true
    }
    
    func didEndEditing(_ sender: UITextField) {
        isEditingCity = false
    }
    
}
