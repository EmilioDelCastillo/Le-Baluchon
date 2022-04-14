//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var weatherModuleTop: WeatherModule!
    @IBOutlet weak var weatherModuleBottom: WeatherModule!
    
    let weatherService = WeatherService()
    var locationManager: CLLocationManager!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityField.delegate = self
        weatherModuleBottom.delegate = self
        
        // TODO: Remove magic numbers (New York coordinates)
        loadAndSetWeather(for: Location(lat: 40.712784, lon: -74.005941), in: weatherModuleTop)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /// Loads the weather data for the given city in the given module.
    /// - Parameters:
    ///   - city: The name of the city whose weather will be loaded.
    ///   - module: The module who whill display the weather data.
    func loadAndSetWeather(for location: Location, in module: WeatherModule) {
        Task {
            do {
                let weather = try await weatherService.getWeather(latitude: location.lat,
                                                                  longitude: location.lon)
                
                set(weather: weather, in: module)
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
    
    /// Fills the weather fields in the weather module with the given data.
    /// - Parameters:
    ///   - weather: The weather data.
    ///   - module: The module in which to load the data.
    private func set(weather: Weather, in module: WeatherModule) {
        module.weather = weather
    }
    
    /// Creates a simple UIAlertController object with the given title and message and an "OK" button.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    /// - Returns: The aforementioned UIAlertController.
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
