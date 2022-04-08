//
//  WeatherModule.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 11/03/2022.
//

import UIKit

@objc protocol WeatherModuleDelegete {
    @objc optional func didOpenSettings()
}

@IBDesignable
class WeatherModule: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var minMaxLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var mainTemperatureLabel: UILabel!
    @IBOutlet private weak var mainUnitLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle(for: WeatherModule.self).loadNibNamed("WeatherModule", owner: self)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public var editable: Bool = false {
        didSet {
            editButton?.isHidden = !editable
        }
    }
    
    public weak var delegate: WeatherModuleDelegete?
    
    /// The number part of the displayed temperature
    public var mainTemperature: Int = 0 {
        didSet {
            mainTemperatureLabel.text = "\(mainTemperature)"
        }
    }
    
    public var temperatureUnit: TemperatureUnit = .celcius {
        didSet {
            mainUnitLabel.text = temperatureUnit.rawValue
        }
    }
    
    public var windSpeed: Int! {
        didSet {
            windLabel.text = "\(windSpeed * 36 / 10) km/h"
        }
    }
    
    public var humidity: Int! {
        didSet {
            humidityLabel.text = "\(humidity!) %"
        }
    }
    
    public var pressure: Int! {
        didSet {
            pressureLabel.text = "\(pressure!) hPa"
        }
    }
    
    public var minMax: (Int, Int)! {
        didSet {
            minMaxLabel.text = "min : \(minMax.0)° | max : \(minMax.1)°"
        }
    }
    
    public var cityName: String! {
        didSet {
            cityNameLabel.text = cityName
        }
    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        delegate?.didOpenSettings?()
    }
    
}
