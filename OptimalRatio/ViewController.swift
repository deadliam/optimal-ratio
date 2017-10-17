//
//  ViewController.swift
//  TestTask
//
//  Created by Anatoly Kasyanov on 10/10/17.
//  Copyright © 2017 MacPaw. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate, NSComboBoxDelegate, NSUserNotificationCenterDelegate {

    @IBOutlet weak var NameField: NSTextField!
    @IBOutlet weak var BirthdayPicker: NSDatePicker!
    @IBOutlet weak var WeightField: NSTextField!
    @IBOutlet weak var HeightField: NSTextField!
    @IBOutlet weak var CalculateButton: NSButton!
    @IBOutlet weak var ResultLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameField.delegate = self
//        BirthdayPicker.delegate = self
        WeightField.delegate = self
        HeightField.delegate = self
        ResultLabel.delegate = self
        updateButtonEnabledState()
        NSUserNotificationCenter.default.delegate = self
    
    }

    func deliverNotification(title: String, subtitle: String, text: String) {
        let notification = NSUserNotification()
        notification.deliveryDate = Date()
        notification.hasActionButton = true
//        notification.actionButtonTitle = "Agree"
        notification.title = title
        notification.informativeText = text
        notification.subtitle = subtitle
//        notification.responsePlaceholder = "Placeholder"
        notification.hasReplyButton = true
        notification.contentImage = NSImage(imageLiteralResourceName: "NotificationImage")
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        updateButtonEnabledState()
        let charsSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numSet = "0123456789"
        if NameField == notification.object as? NSTextField {
            let characterSet: CharacterSet = (CharacterSet(charactersIn: charsSet).inverted as NSCharacterSet) as CharacterSet
            NameField.stringValue = (NameField.stringValue.components(separatedBy: characterSet) as NSArray).componentsJoined(by: "")
        }
        if WeightField == notification.object as? NSTextField {
            let characterSet: CharacterSet = (CharacterSet(charactersIn: numSet).inverted as NSCharacterSet) as CharacterSet
            WeightField.stringValue = (WeightField.stringValue.components(separatedBy: characterSet) as NSArray).componentsJoined(by: "")
        }
        if HeightField == notification.object as? NSTextField {
            let characterSet: CharacterSet = (CharacterSet(charactersIn: numSet).inverted as NSCharacterSet) as CharacterSet
            HeightField.stringValue = (HeightField.stringValue.components(separatedBy: characterSet) as NSArray).componentsJoined(by: "")
        }
    }
    
//    func comboBoxSelectionDidChange(_ notification: Notification) {
//        updateButtonEnabledState()
//    }
    
    func updateButtonEnabledState() {
        CalculateButton.isEnabled = NameField.stringValue.isEmpty == false &&
            WeightField.stringValue.isEmpty == false &&
            HeightField.stringValue.isEmpty == false
//            languageComboBox.indexOfSelectedItem != NSNotFound
    }
    
    func calculateAge(birth: Date) -> Int {
        let now = Date()
        let birthday: Date = birth
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year!
    }
    
    func getOptimalRatio(mass: Double, height: Double) -> String {
        let bodyMassIndex = mass / height * 0.1 * 2
        var interpretation = "ERROR"
        if bodyMassIndex < 18.5 {
            interpretation = "Underweight Body!"
        } else if bodyMassIndex > 18.5 && bodyMassIndex < 24.9 {
            interpretation = "Normal weight"
        } else if bodyMassIndex > 25 && bodyMassIndex < 29.9 {
            interpretation = "Overweight (pre-obese)"
        } else if bodyMassIndex > 30 && bodyMassIndex < 34.9 {
            interpretation = "Obesity (1st degree)"
        } else if bodyMassIndex > 35 && bodyMassIndex < 39.9 {
            interpretation = "Obesity (2nd degree)"
        } else if bodyMassIndex > 40 {
            interpretation = "Obesity (3rd degree)"
        }
        return interpretation
    }
    
    @IBAction func buttonClick(button: AnyObject) {
        print("Test log")
        
//        let indexCombo = languageComboBox.indexOfSelectedItem
//        let valuecombo = languageComboBox.itemObjectValue(at: indexCombo)
        
        var optimalRatio = ""
        if let weight = Double(WeightField.stringValue), let height = Double(HeightField.stringValue) {
            optimalRatio = getOptimalRatio(mass: weight, height: height)
        } else {
            optimalRatio = "Not a valid number"
            print("Not a valid number")
        }
    
        let age = "Age: \(calculateAge(birth: BirthdayPicker.dateValue))"
        deliverNotification(title: NameField.stringValue, subtitle: age, text: optimalRatio)
        ResultLabel.stringValue += optimalRatio
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

