//
//  WeatherSettingsViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 08/04/2022.
//

import UIKit

enum SettingOptionsType {
    case plain(model: SettingsOption)
    case menu(model: SettingsMenuOption)
    case `switch`(model: SettingsSwitchOption)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> ())
    var isOn: Bool
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> ())
}

struct SettingsMenuOption {
    let title: String
    let icon: UIImage?
    let menuOptions: [UIMenuElement]
}

class WeatherSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var options = [SettingOptionsType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setOptions()
    }
    
    private func setOptions() {
        options = [
            .menu(model: SettingsMenuOption(title: "Temperature unit",
                                            icon: UIImage(systemName: "thermometer"),
                                            menuOptions: [
                                                UIAction(title: TemperatureUnit.Celcius.rawValue) { _ in
                                                    UserDefaults.temperatureUnit = .Celcius
                                                    NotificationCenter.weatherSettingsChanged()
                                                },
                                                UIAction(title: TemperatureUnit.Fahrenheit.rawValue) { _ in
                                                    UserDefaults.temperatureUnit = .Fahrenheit
                                                    NotificationCenter.weatherSettingsChanged()
                                                }
                                            ])),
            
            .menu(model: SettingsMenuOption(title: "Default units",
                                            icon: UIImage(systemName: "globe.europe.africa"),
                                            menuOptions: [
                                                UIAction(title: "Metric") { _ in
                                                    UserDefaults.unitSystem = .metric
                                                    
                                                },
                                                UIAction(title: "Imperial") { _ in
                                                    UserDefaults.unitSystem = .imperial
                                                    
                                                }
                                            ])),
        
            .plain(model: SettingsOption(title: "Default city",
                                         icon: UIImage(systemName: "mappin.and.ellipse")) { [weak self] in
                                             let cityPrompt = UIAlertController(title: "Enter the default city.",
                                                                                message: "Leave empty to use your current location.",
                                                                                preferredStyle: .alert)
                                             
                                             let setCity = UIAlertAction(title: "OK", style: .default) { _ in
                                                 guard let answer = cityPrompt.textFields?[0], let text = answer.text else { return }
                                                 if text.isEmpty {
                                                     UserDefaults.defaultLocation = .current
                                                 } else {
                                                     let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                                                     let capitalizedText = trimmedText.prefix(1).capitalized + trimmedText.dropFirst()
                                                     UserDefaults.defaultLocation = .custom(capitalizedText)
                                                 }
                                                 self?.tableView.reloadData()
                                                 NotificationCenter.weatherSettingsChanged()
                                             }
                                             
                                             let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                                                 cityPrompt.dismiss(animated: true)
                                             }
                                             
                                             cityPrompt.addTextField()
                                             let textfield = cityPrompt.textFields?[0]
                                             textfield?.placeholder = "Current location"
                                             textfield?.clearButtonMode = .always
                                             
                                             switch UserDefaults.defaultLocation {
                                             case .current:
                                                 break
                                             case .custom(let customLocation):
                                                 textfield?.text = customLocation
                                             }
                                             
                                             cityPrompt.addAction(setCity)
                                             cityPrompt.addAction(cancelAction)
                                             self?.present(cityPrompt, animated: true)
                                         })
        ]
    }
}

extension WeatherSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = options[indexPath.row]
        
        switch model {
        case .plain(model: let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! SettingsTableViewCell
            cell.iconImageView.image = model.icon
            cell.label.text = model.title
            
            switch UserDefaults.defaultLocation {
            case .current:
                cell.valueLabel.text = "Current Location"
                
            case .custom(let customLocation):
                cell.valueLabel.text = customLocation
            }
            
            return cell
            
        case .menu(model: let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! SettingsMenuTableViewCell
            cell.label.text = model.title
            cell.iconImageView.image = model.icon
            cell.configureMenu(with: model.menuOptions)
            
            // Select the correct item in the menu
            let temperatureUnit = UserDefaults.temperatureUnit
            switch temperatureUnit {
            case .Celcius:
                cell.updateActionState(actionTitle: TemperatureUnit.Celcius.rawValue)
            case .Fahrenheit:
                cell.updateActionState(actionTitle: TemperatureUnit.Fahrenheit.rawValue)
            }
            
            return cell
            
        case .switch(model: let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SettingsSwitchTableViewCell
            cell.label.text = model.title
            cell.iconImageView.image = model.icon
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = options[indexPath.row]
        switch type {
        case .plain(model: let model):
            model.handler()
        case .menu(_):
            break
        case .switch(model: let model):
            model.handler()
        }
    }
}


