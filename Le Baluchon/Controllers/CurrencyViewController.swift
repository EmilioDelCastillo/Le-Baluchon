//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 29/04/2022.
//

import UIKit

final class CurrencyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var numpadModule: NumpadModule!
    
    private let service = CurrencyService()
    private var currency: Currency?
    private let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                currency = try await service.getCurrentRate()
                updateOutputLabel()
            } catch {
                print(error)
            }
        }
        
        inputTextField.delegate = self
        outputTextField.delegate = self
        numpadModule.delegate = self
        formatter.maximumFractionDigits = 3
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(deleteCharacter))
        gesture.direction = [.left, .right]
        inputTextField.addGestureRecognizer(gesture)
    }
    
    /// Updates the label with the converted value.
    private func updateOutputLabel() {
        guard let text = inputTextField.text else { return }
        let value = Double(text)
        
        guard let convertedValue = currency?.convert(from: value ?? 1) as? NSNumber else { return }
        outputTextField.text = formatter.string(from: convertedValue)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        false
    }
    
    /// Deletes a character from the input text field.
    @objc private func deleteCharacter() {
        guard let text = inputTextField.text, text.count > 0 else { return }
        inputTextField.text = String(text.dropLast())
        updateOutputLabel()
    }
}

extension CurrencyViewController: NumpadModuleDelegate {
    public func didPressButton(value: Int, _ sender: UIButton) {
        guard let text = inputTextField.text else { return }
        let newText = text + value.string
        inputTextField.text = newText
        updateOutputLabel()
    }
    
    public func didPressComma() {
        guard let text = inputTextField.text, !text.isEmpty, !text.contains(".") else { return }
        let newText = text + "."
        inputTextField.text = newText
        updateOutputLabel()
    }
}
