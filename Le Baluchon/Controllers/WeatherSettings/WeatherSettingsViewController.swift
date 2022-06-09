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
    let cellConfiguration: ((_ cell: SettingsMenuTableViewCell) -> ())?
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
                                            ],
                                            cellConfiguration: { cell in
                                                let temperatureUnit = UserDefaults.temperatureUnit
                                                switch temperatureUnit {
                                                case .Celcius:
                                                    cell.updateActionState(actionTitle: TemperatureUnit.Celcius.rawValue)
                                                case .Fahrenheit:
                                                    cell.updateActionState(actionTitle: TemperatureUnit.Fahrenheit.rawValue)
                                                }
                                            }
                                           )),
            
            .menu(model: SettingsMenuOption(title: "Default units",
                                            icon: UIImage(systemName: "globe.europe.africa"),
                                            menuOptions: [
                                                UIAction(title: UnitSystem.Metric.rawValue) { _ in
                                                    UserDefaults.unitSystem = .Metric
                                                    NotificationCenter.weatherSettingsChanged()
                                                },
                                                UIAction(title: UnitSystem.Imperial.rawValue) { _ in
                                                    UserDefaults.unitSystem = .Imperial
                                                    NotificationCenter.weatherSettingsChanged()
                                                }
                                            ],
                                            cellConfiguration: { cell in
                                                let speedUnit = UserDefaults.unitSystem
                                                switch speedUnit {
                                                case .Metric:
                                                    cell.updateActionState(actionTitle: UnitSystem.Metric.rawValue)
                                                case .Imperial:
                                                    cell.updateActionState(actionTitle: UnitSystem.Imperial.rawValue)
                                                }
                                            }
                                           ))
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
        case .plain(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! SettingsTableViewCell
            return cell
            
        case .menu(model: let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! SettingsMenuTableViewCell
            cell.label.text = model.title
            cell.iconImageView.image = model.icon
            cell.configureMenu(with: model.menuOptions)
            model.cellConfiguration?(cell)
            
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


