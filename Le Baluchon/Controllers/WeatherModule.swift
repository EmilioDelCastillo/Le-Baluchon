//
//  WeatherModule.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 11/03/2022.
//

import UIKit

@IBDesignable
class WeatherModule: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var minMaxLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var mainTemperatureLabel: UILabel!
    
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
    public var mainTemperature: Int = 0 {
        didSet {
            /// The number part of the displayed temperature
            let baseAttributes: [NSMutableAttributedString.Key: Any] = [
                .font: UIFont(name: "ArialRoundedMTBold", size: 100)!,
                .foregroundColor: UIColor.white
            ]
            
            /// The "°X" part of the displayed temperature
            let unitAttributes: [NSMutableAttributedString.Key: Any] = [
                .baselineOffset: 45,
                .font: UIFont(name: "ArialRoundedMTBold", size: 35)!,
                .foregroundColor: UIColor(named: "Detail Orange", in: Bundle(for: WeatherModule.self), compatibleWith: nil)!
            ]
            
            let baseStringSize = "\(mainTemperature)".count

            let attributedString = NSMutableAttributedString(string: "\(mainTemperature)°C", attributes: baseAttributes)
            attributedString.addAttributes(unitAttributes, range: NSRange(location: baseStringSize, length: 2))
            
            mainTemperatureLabel.attributedText = attributedString
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
}
