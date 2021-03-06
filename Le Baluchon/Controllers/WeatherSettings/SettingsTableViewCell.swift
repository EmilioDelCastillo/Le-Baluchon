//
//  SettingsCellTableViewCell.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 08/04/2022.
//

import UIKit

public class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}

final class SettingsSwitchTableViewCell: SettingsTableViewCell {
    @IBOutlet weak var `switch`: UISwitch!
}

public final class SettingsMenuTableViewCell: SettingsTableViewCell {
    @IBOutlet weak var menuButton: UIButton!
    
    public func configureMenu(title: String = "", with elements: [UIMenuElement]) {
        let menu = UIMenu(title: title, image: nil, identifier: nil, options: .displayInline, children: elements)
        menuButton.menu = menu
    }
    
    /// Updates the state of the item in the menu with the given title, setting it to `.on`.
    /// - Parameter actionTitle: The title of the item to update.
    public func updateActionState(actionTitle: String) {
        menuButton.menu?.children.forEach {
            guard let action = $0 as? UIAction else { return }
            if action.title == actionTitle {
                action.state = .on
            }
        }
    }
}
