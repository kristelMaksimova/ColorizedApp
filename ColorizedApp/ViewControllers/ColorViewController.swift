//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Kristel Maximova on 12.01.2022.
//

import UIKit

class ColorViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    // MARK: - Public Properties
    var delegate: ColorViewControllerDelegate!
    var viewColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        
        redSlider.tintColor = .red
        greenSlider.tintColor = .green
        
        colorView.backgroundColor = viewColor
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
        
    }
    
    // MARK: - IB Actions
    @IBAction func rgbSlider(_ sender: UISlider) {
        
        switch sender {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTextField)
        case greenSlider:
            setValue(for: greenLabel)
            setValue(for: greenTextField)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTextField)
        }
        
        setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate?.setColor(colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension ColorViewController {
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redLabel: label.text = string(from: redSlider)
            case greenLabel: label.text = string(from: greenSlider)
            default: label.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTextField: textField.text = string(from: redSlider)
            case greenTextField: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: viewColor)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    // Значения RGB
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension ColorViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text) {
            switch textField {
            case redTextField:
                redSlider.setValue(currentValue, animated: true)
                setValue(for: redLabel)
            case greenTextField:
                greenSlider.setValue(currentValue, animated: true)
                setValue(for: greenLabel)
            default:
                blueSlider.setValue(currentValue, animated: true)
                setValue(for: blueLabel)
            }
            
            setColor()
            return
        }
        
        showAlert(title: "Wrong format!", message: "Please enter correct value")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}
