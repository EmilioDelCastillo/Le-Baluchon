//
//  NumpadModule.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 03/05/2022.
//

import UIKit

public protocol NumpadModuleDelegate: AnyObject {
    func didPressButton(value: Int, _ sender: UIButton)
    func didPressComma()
}

@IBDesignable
public final class NumpadModule: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private var buttons: [UIButton]!
    
    public weak var delegate: NumpadModuleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle(for: NumpadModule.self).loadNibNamed("NumpadModule", owner: self)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        for (index, element) in buttons.enumerated() {
            element.setAttributedTitle(
                NSAttributedString(string: index.string, attributes: [.font: UIFont(name: "AppleSDGothicNeo-Thin", size: 40)!]),
                for: .normal)
            element.addTarget(self, action: #selector(didPressButton(sender:)), for: .touchUpInside)
            if index == 0 {
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
                element.addGestureRecognizer(longPressGesture)
            }
        }
    }
    
    @objc private func didPressButton(sender: UIButton) {
        guard let label = sender.titleLabel,
              let value = Int(label.text!)
        else { return }
        delegate?.didPressButton(value: value, sender)
    }
    
    @objc private func didLongPress(sender: UIButton) {
        delegate?.didPressComma()
    }
}
