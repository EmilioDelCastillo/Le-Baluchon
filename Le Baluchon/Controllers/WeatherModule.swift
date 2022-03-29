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
            let attributes: [NSMutableAttributedString.Key: Any] = [.font: UIFont(name: "ArialRoundedMTBold", size: 100)!,
                                                                    .foregroundColor: UIColor.white]
            let baseStringSize = "\(mainTemperature)".count

            let attributedString = NSMutableAttributedString(string: "\(mainTemperature)°C", attributes: attributes)

            attributedString.addAttribute(.baselineOffset, value: 45, range: NSRange(location: baseStringSize, length: 2))
            attributedString.addAttribute(.font, value: UIFont(name: "ArialRoundedMTBold", size: 35)!, range: NSRange(location: baseStringSize, length: 2))
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "Detail Orange", in: Bundle(for: AppDelegate.self), compatibleWith: nil)!, range: NSRange(location: baseStringSize, length: 2))

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
            minMaxLabel.text = "min : \(minMax.0) | max : \(minMax.1)"
        }
    }
    
    public var cityName: String! {
        didSet {
            cityNameLabel.text = cityName
        }
    }
}
