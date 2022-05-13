//
//  WeatherModule.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 11/03/2022.
//

import UIKit

@objc protocol WeatherModuleDelegete {
    @objc optional func didOpenSettings()
    @objc optional func didChangeCityName(to city: String)
    @objc optional func didBeginEditing(_ sender: UITextField)
    @objc optional func didEndEditing(_ sender: UITextField)
}

@IBDesignable
class WeatherModule: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var minMaxLabel: UILabel!
    @IBOutlet private weak var cityNameTextField: UITextField!
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
        
        cityNameTextField.delegate = self
        cityNameTextField.attributedPlaceholder = NSAttributedString(string: "Current city", attributes: [
            .foregroundColor: UIColor.systemGray
        ])
        
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
            cityNameTextField?.borderStyle = editable ? .roundedRect : .none
            cityNameTextField?.isEnabled = editable
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
        cityNameTextField.text = weather.cityName
    }
    
    @IBAction func openSettings(_ sender: UIButton) {
        delegate?.didOpenSettings?()
    }
    
}

extension WeatherModule: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.didChangeCityName?(to: textField.text ?? "")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing?(textField)
    }
}
