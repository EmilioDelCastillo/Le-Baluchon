//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import UIKit

final class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var weatherModuleTop: WeatherModule!
    @IBOutlet weak var weatherModuleBottom: WeatherModule!
    
    let weatherService = WeatherService()
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        cityField.delegate = self
        loadAndSetWeather(for: "New York", in: weatherModuleTop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /// Loads the weather data for the given city in the given module.
    /// - Parameters:
    ///   - city: The name of the city whose weather will be loaded.
    ///   - module: The module who whill display the weather data.
    private func loadAndSetWeather(for city: String, in module: WeatherModule) {
        Task {
            do {
                let weather = try await weatherService.getWeather(city: city)
                
                module.cityName = weather.cityName
                module.mainTemperature = weather.temp
                module.humidity = weather.humidity
                module.pressure = weather.pressure
                module.minMax = (weather.tempMin, weather.tempMax)
                module.windSpeed = weather.windSpeed
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
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        Task {
            do {
                spinner.startAnimating()
                loadAndSetWeather(for: text, in: weatherModuleBottom)
                spinner.stopAnimating()
            }
        }
        return false
    }
    
    private func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
