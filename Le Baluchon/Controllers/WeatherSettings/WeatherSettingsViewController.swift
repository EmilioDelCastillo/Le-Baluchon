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

protocol WeatherSettingsViewControllerDelegate: AnyObject {
    func didUpdateSettings()
}

class WeatherSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var options = [SettingOptionsType]()
    weak var delegate: WeatherSettingsViewControllerDelegate?
    
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
                                                UIAction(title: TemperatureUnit.Celcius.rawValue) { [weak self] _ in
                                                    UserDefaults.temperatureUnit = .Celcius
                                                    self?.delegate?.didUpdateSettings()
                                                },
                                                UIAction(title: TemperatureUnit.Fahrenheit.rawValue) { [weak self] _ in
                                                    UserDefaults.temperatureUnit = .Fahrenheit
                                                    self?.delegate?.didUpdateSettings()
                                                }
                                            ])),
            
            .menu(model: SettingsMenuOption(title: "Default units",
                                            icon: UIImage(systemName: "globe.europe.africa"),
                                            menuOptions: [
                                                UIAction(title: "Metric") { [weak self] _ in
                                                    UserDefaults.unitSystem = .metric
                                                    self?.delegate?.didUpdateSettings()
                                                },
                                                UIAction(title: "Imperial") { [weak self] _ in
                                                    UserDefaults.unitSystem = .imperial
                                                    self?.delegate?.didUpdateSettings()
                                                }
                                            ])),
        
            .plain(model: SettingsOption(title: "Default city",
                                         icon: UIImage(systemName: "mappin.and.ellipse"),
                                         handler: { [weak self] in
                                             print("Something something default location")
                                             self?.delegate?.didUpdateSettings()
                                         }))
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
            cell.valueLabel.text = "Current Location"
            
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


