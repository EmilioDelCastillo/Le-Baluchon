//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by Emilio Del Castillo on 17/05/2022.
//

import UIKit

final class TranslationViewController: UIViewController {
    
    @IBOutlet weak var sourceTextField: UITextView!
    @IBOutlet weak var targetTextField: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let translationService = TranslationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceTextField.delegate = self
        targetTextField.delegate = self
    }
}

extension TranslationViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == sourceTextField else { return }
        Task {
            spinner.startAnimating()
            let translation = try await translationService.translate(text: textView.text, to: "EN")
            spinner.stopAnimating()
            targetTextField.text = translation.text
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
