//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 29/04/2022.
//

import UIKit

class CurrencyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var numpadModule: NumpadModule!
    
    private let service = CurrencyService()
    private var currency: Currency?
    
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
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(deleteCharacter))
        gesture.direction = [.left]
        inputTextField.addGestureRecognizer(gesture)
    }
    
    /// Updates the label with the converted value.
    private func updateOutputLabel() {
        guard let text = inputTextField.text,
              let value = Double(text)
        else { return }
        
        let convertedValue = currency?.convert(from: value)
        outputTextField.text = convertedValue?.string
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
    func didPressButton(value: Int, _ sender: UIButton) {
        guard let text = inputTextField.text else { return }
        let newText = text + value.string
        inputTextField.text = newText
        updateOutputLabel()
    }
}
