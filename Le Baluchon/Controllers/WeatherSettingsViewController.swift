//
//  WeatherSettingsViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 08/04/2022.
//

import UIKit

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> ())
}

class WeatherSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var options = [SettingsOption]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setOptions()
    }
    
    private func setOptions() {
        options = [
            SettingsOption(title: "Temperature unit", icon: nil, handler: {}),
            SettingsOption(title: "Default city", icon: nil, handler: {})
        ]
    }
}

extension WeatherSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = options[indexPath.row].title
        
        cell.contentConfiguration = content
        return cell
    }
}


