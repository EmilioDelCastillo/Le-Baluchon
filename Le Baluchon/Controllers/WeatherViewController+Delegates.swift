//
//  WeatherViewController+Delegates.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 08/04/2022.
//

import UIKit
import CoreLocation

extension WeatherViewController: UITextFieldDelegate, CLLocationManagerDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        Task {
            do {
                spinner.startAnimating()
                let location = try await weatherService.getLocation(from: text)
                loadAndSetWeather(for: location, in: weatherModuleBottom)
                spinner.stopAnimating()
            }
            catch WeatherServiceError.cityNotFound {
                spinner.stopAnimating()
                present(createAlert(title: "Error", message: "We could not find your city."), animated: true)
                
            }
            catch BaluchonError.missingConfig {
                spinner.stopAnimating()
                present(createAlert(title: "Error", message: "An error occurred."), animated: true)
                
            }
            catch BaseServiceError.networkError {
                spinner.stopAnimating()
                present(createAlert(title: "Error", message: "Network error."), animated: true)
            }
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let test = Location(name: "",
                            lat: location.coordinate.latitude,
                            lon: location.coordinate.longitude,
                            country: "")
        loadAndSetWeather(for: test, in: weatherModuleBottom)
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
}

extension WeatherViewController: WeatherSettingsViewControllerDelegate {
    func didUpdateSettings() {
        loadAndSetWeather(for: Location(lat: 40.712784, lon: -74.005941), in: weatherModuleTop)
    }
}
