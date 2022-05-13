//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 10/03/2022.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var weatherModuleTop: WeatherModule!
    @IBOutlet weak var weatherModuleBottom: WeatherModule!
    
    let weatherService = WeatherService()
    var locationManager: CLLocationManager!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModuleBottom.delegate = self
        
        // TODO: Remove magic numbers (New York coordinates)
        loadAndSetWeather(for: Location(lat: 40.712784, lon: -74.005941), in: weatherModuleTop)
        loadUserWeather()
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserWeather),
                                               name: LeBaluchonNotification.weatherSettingsChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserWeather),
                                               name: LeBaluchonNotification.weatherCityChanged,
                                               object: nil)
        containerStackView.bottomAnchor.constraint(greaterThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -20).isActive = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: LeBaluchonNotification.weatherSettingsChanged,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: LeBaluchonNotification.weatherCityChanged,
                                                  object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func loadUserWeather() {
        switch UserDefaults.defaultLocation {
        case .current:
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
            
        case .custom(let customLocation):
            Task {
                do {
                    spinner.startAnimating()
                    let location = try await weatherService.getLocation(from: customLocation)
                    loadAndSetWeather(for: location, in: weatherModuleBottom)
                    spinner.stopAnimating()
                }
                catch WeatherServiceError.cityNotFound {
                    spinner.stopAnimating()
                    let alert = createAlert(title: "Error", message: "We could not find your city.")
                    alert.addAction(UIAlertAction(title: "Use current location", style: .default, handler: { [weak self] _ in
                        UserDefaults.defaultLocation = .current
                        self?.loadUserWeather()
                    }))
                    present(alert, animated: true)
                    
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
        
    }
    
    /// Loads the weather data for the given city in the given module.
    /// - Parameters:
    ///   - location: The location of the city whose weather will be loaded.
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
        switch module {
        case weatherModuleTop:
            module.weather = weather
            
        case weatherModuleBottom:
            switch UserDefaults.defaultLocation {
            case .current:
                module.weather = weather
                
            case .custom(let customLocation):
                // This ensures that the name given by the user is the same that is displayed.
                // Sometimes the fetched locations will give a different name for the same place
                // when the coordinates are provided.
                var newWeather = weather
                newWeather.cityName = customLocation
                module.weather = newWeather
            }
            
        default:
            preconditionFailure("The given module has not been implemented.")
        }
        
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
