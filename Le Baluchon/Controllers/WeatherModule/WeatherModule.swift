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
        NotificationCenter.default.addObserver(self, selector: #selector(loadWeather), name: LeBaluchonNotification.weatherSettingsChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: LeBaluchonNotification.weatherSettingsChanged, object: nil)
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
    
    public var weather: Weather? {
        didSet {
            loadWeather()
        }
    }
    
    @objc func loadWeather() {
        guard let weather = weather else {
            return
        }

        mainTemperatureLabel.text = "\(weather.temp)"
        switch UserDefaults.temperatureUnit {
        case .Celcius:
            mainUnitLabel.text = "°C"
        case .Fahrenheit:
            mainUnitLabel.text = "°F"
        }
        
        windLabel.text = "\(weather.windSpeed * 36 / 10) km/h"
        humidityLabel.text = "\(weather.humidity) %"
        pressureLabel.text = "\(weather.pressure) hPa"
        minMaxLabel.text = "min : \(weather.tempMin)° | max : \(weather.tempMax)°"
        cityNameLabel.text = weather.cityName
    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        delegate?.didOpenSettings?()
    }
    
}
