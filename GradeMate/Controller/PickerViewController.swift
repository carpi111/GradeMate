//
//  PickerViewController.swift
//  GradeMate
//
//  Created by Vince Carpino on 1/11/18.
//  Copyright © 2018 The Half-Blood Jedi. All rights reserved.
//

import Foundation
import FlatUIKit
import PickerView

class PickerViewController: UIViewController {
    // MARK: - VALUES
    var currentGrade = 0
    var decimalValue = 0.0
    var examWeight   = 0
    var desiredGrade = 0
    var scoreValue   = 0.0
    
    var warning      = ""
    var dismiss      = ""
    var value        = ""
    
    var effect: UIVisualEffect!                // FOR BLUR EFFECT
    
    var statusBarIsHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    // MARK: - PICKERVIEWS
    @IBOutlet weak var picker1: PickerView!
    @IBOutlet weak var picker2: PickerView!
    @IBOutlet weak var picker3: PickerView!
    @IBOutlet weak var picker4: PickerView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var resultView: UIView!
    @IBOutlet weak var resultViewScoreLabel: UILabel!
    @IBOutlet weak var resultViewWarningLabel: UILabel!
    @IBOutlet weak var resultViewDismissButton: FUIButton!
    
    // MARK: - NUMBER ARRAYS
    let numbers1: [Int] = {
        var nums = [Int]()
        
        for i in (1...100).reversed() {
            nums.append(i)
        }
        
        return nums
    }()
    
    let numbers2: [Double] = {
        var nums = [Double]()
        
        for i in 0...9 {
            nums.append(Double(i) / 10.0)
        }
        
        return nums
    }()
    
    let numbers3: [Int] = {
        var nums = [Int]()
        
        for i in 1...100 {
            nums.append(i)
        }
        
        return nums
    }()
    
    let numbers4: [Int] = {
        var nums = [Int]()
        
        for i in (1...100).reversed() {
            nums.append(i)
        }
        
        return nums
    }()
    
    // MARK: - STRING ARRAYS
    let stringNumbers1: [String] = {
        var strNums = [String]()
        
        for i in (1...100).reversed() {
            strNums.append(String(i))
        }
        
        return strNums
    }()
    
    let stringNumbers2: [String] = {
        var strNums = [String]()
        
        for i in 0...9 {
            var stringDecimal = (String(Double(i) / 10.0) + "%")
            
            // REMOVE LEADING ZERO ON DECIMAL
            stringDecimal.remove(at: stringDecimal.startIndex)
            
            strNums.append(stringDecimal)
        }
        
        return strNums
    }()
    
    let stringNumbers3: [String] = {
        var strNums = [String]()
        
        for i in 1...100 {
            strNums.append(String(i) + "%")
        }
        
        return strNums
    }()
    
    let stringNumbers4: [String] = {
        var strNums = [String]()
        
        for i in (1...100).reversed() {
            strNums.append(String(i) + "%")
        }
        
        return strNums
    }()
    
    // MARK: - GRADIENT IMAGE
    let letterGradientImage = UIImage(named: "GradeGradient")
    
    
    override func viewDidLoad() {
        configurePicker(picker: picker1, stringArray: stringNumbers1)
        configurePicker(picker: picker2, stringArray: stringNumbers2)
        configurePicker(picker: picker3, stringArray: stringNumbers3)
        configurePicker(picker: picker4, stringArray: stringNumbers4)
        
        setCurrentGrade(val: 100)
        setDecimalValue(val: 0.1)
        setExamWeight(val: 1)
        setDesiredGrade(val: 100)
        
        effect = visualEffectView.effect         // STORES EFFECT IN VAR TO USE LATER IN ANIMATION
        visualEffectView.effect = nil            // TURNS OFF BLUR WHEN VIEW LOADS
        visualEffectView.isHidden = true         // HIDES BLUR EFFECT SO BUTTONS CAN BE USED
        
        resultView.layer.cornerRadius = 10        // ROUNDS OFF CORNERS OF POP UP VIEW
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }
    
    // MARK: - CONFIGURE PICKER
    func configurePicker(picker: PickerView, stringArray: [String]) {
        picker.dataSource = self
        picker.delegate   = self
        picker.backgroundColor = .clear
        picker.scrollingStyle  = .default
        picker.selectionStyle  = .defaultIndicator
        picker.currentSelectedRow = stringArray.index(of: stringArray.first!)
    }
}

// MARK: - PICKERVIEW -

// MARK: DATA SOURCE
extension PickerViewController: PickerViewDataSource {
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        switch pickerView {
        case picker1:
            return stringNumbers1.count
        case picker2:
            return stringNumbers2.count
        case picker3:
            return stringNumbers3.count
        case picker4:
            return stringNumbers4.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        switch pickerView {
        case picker1:
            return stringNumbers1[index]
        case picker2:
            return stringNumbers2[index]
        case picker3:
            return stringNumbers3[index]
        case picker4:
            return stringNumbers4[index]
        default: return ""
        }
    }
}

// MARK: DELEGATE
extension PickerViewController: PickerViewDelegate {
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 35.0
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        switch pickerView {
        case picker1:
            setCurrentGrade(val: numbers1[index])
            print(getCurrentGrade())
        case picker2:
            setDecimalValue(val: numbers2[index])
            print(getDecimalValue())
        case picker3:
            setExamWeight(val: numbers3[index])
            print(getExamWeight())
        case picker4:
            setDesiredGrade(val: numbers4[index])
            print(getDesiredGrade())
        default: break
        }
        
        calculate(currentGradeInt: self.currentGrade, decimalValue: self.decimalValue, examWeightInt: self.examWeight, desiredGradeInt: self.desiredGrade)
        print(getScoreValue())
        
        setGradeValue(value: String(format: "%.0f", self.scoreValue) + "%")
        
        checkScoreValue(value: self.scoreValue)
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            if (highlighted) {
                label.font = UIFont(name: "Courier-Bold", size: 26.0)
            } else {
                label.font = UIFont(name: "Courier-Bold", size: 26.0)
            }
        } else {
            if (highlighted) {
                label.font = UIFont(name: "Courier-Bold", size: 26.0)
            } else {
                label.font = UIFont(name: "Courier-Bold", size: 26.0)
            }
        }
        
        if pickerView == picker2 {
            label.textAlignment = .left
        }
        
        if (highlighted) {
            label.textColor = .clouds()
            switch pickerView {
            case picker1:
                let itemTextInt = Int(label.text!)
                let coords = CGPoint(x: 0, y: ((itemTextInt!)-1))
                picker1.defaultSelectionIndicator.backgroundColor = letterGradientImage?.getPixelColor(pos: coords)
            case picker2:
                picker2.defaultSelectionIndicator.backgroundColor = .clear
            case picker3:
                picker3.defaultSelectionIndicator.backgroundColor = .clear
            case picker4:
                let labelText = label.text!
                let strIndex = labelText.index(of: "%")!
                let subString = String(labelText[..<strIndex])
                let itemTextInt = Int(subString)
                let coords = CGPoint(x: 0, y: ((itemTextInt!)-1))
                picker4.defaultSelectionIndicator.backgroundColor = letterGradientImage?.getPixelColor(pos: coords)
            default:break
            }
        } else {
            label.textColor = .silver()
        }
    }
    
    func pickerView(_ pickerView: PickerView, viewForRow row: Int, index: Int, highlighted: Bool, reusingView view: UIView?) -> UIView? {
        return nil
    }
}

// MARK: - CALCULATOR
extension PickerViewController {
    
    func calculate(currentGradeInt: Int, decimalValue: Double, examWeightInt: Int, desiredGradeInt: Int) {
        let currentGrade = (Double(currentGradeInt) + decimalValue) / 100.0
        
        let examWeight = Double(examWeightInt) / 100.0
        
        let desiredGrade = Double(desiredGradeInt) / 100.0
        
        setScoreValue(val: floor((( desiredGrade - (1 - examWeight) * currentGrade) / examWeight) * 100))
    }
    
    // MARK: - POP UP ANIMATION
    
    // ANIMATE IN
    func animateIn(viewToAnimate: UIView) {
        self.visualEffectView.isHidden = false
        
        self.view.addSubview(viewToAnimate)                                        // ADD POP UP VIEW TO MAIN VIEW
        viewToAnimate.center = self.view.center                                    // CENTER POP UP VIEW IN MAIN VIEW
        
        viewToAnimate.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)    // MAKE POP UP VIEW SLIGHTLY BIGGER BEFORE IT IS DISPLAYED
        viewToAnimate.alpha = 0
        
        // Animate pop up, returning it to its normal state (identity)
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.effect = self.effect
            viewToAnimate.alpha = 1
            viewToAnimate.transform = CGAffineTransform.identity
        })
        
        statusBarIsHidden = true
    }
    
    // ANIMATE OUT
    func animateOut(viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            viewToAnimate.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            viewToAnimate.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            viewToAnimate.removeFromSuperview()
            self.visualEffectView.isHidden = true
        }
        
        statusBarIsHidden  = false
    }
    
    @IBAction func dismissPopUp(_ sender: FUIButton) {
        animateOut(viewToAnimate: self.resultView)
    }
    
    // MARK: - GETTERS
    func getCurrentGrade() -> Int {
        return self.currentGrade
    }
    
    func getDecimalValue() -> Double {
        return self.decimalValue
    }
    
    func getExamWeight() -> Int {
        return self.examWeight
    }
    
    func getDesiredGrade() -> Int {
        return self.desiredGrade
    }
    
    func getScoreValue() -> Double {
        return self.scoreValue
    }
    
    func getWarning() -> String {
        return self.warning
    }
    
    func getDismiss() -> String {
        return self.dismiss
    }
    
    func getValue() -> String {
        return self.value
    }
    
    // MARK: - SETTERS
    func setCurrentGrade(val: Int) {
        self.currentGrade = val
    }
    
    func setDecimalValue(val: Double) {
        self.decimalValue = val
    }
    
    func setExamWeight(val: Int) {
        self.examWeight = val
    }
    
    func setDesiredGrade(val: Int) {
        self.desiredGrade = val
    }
    
    func setScoreValue(val: Double) {
        self.scoreValue = val
        self.resultViewScoreLabel.text = String(Int(floor(val))) + "%"
    }
    
    func setWarning(warning: String) {
        self.warning = warning
        self.resultViewWarningLabel.text = warning
    }
    
    func setDismiss(message: String) {
        self.dismiss = message
        self.resultViewDismissButton.setTitle(message, for: .normal)
    }
    
    func setGradeValue(value: String) {
        self.value = value
    }
    
    // MARK: - RESPONSES
    func checkScoreValue(value: Double) {
        switch Int(value) {
        // 301+
        case let x where x > 300:
            setWarning(warning: "I think it's safe to say that this is not your best subject.")
            setDismiss(message: "No 💩, Sherlock")
            break
            
        // 201 - 300
        case let x where x > 200:
            setWarning(warning: "Bribery is your only hope at this point...")
            setDismiss(message: "I would never...😈")
            break
            
        // 151 - 200
        case let x where x > 150:
            setWarning(warning: "It's okay to cry...")
            setDismiss(message: "Already am 😭")
            break
            
        // 126 - 150
        case let x where x > 125:
            setWarning(warning: "It's not lookin' good for you...")
            setDismiss(message: "I surrender 🏳")
            break
            
        // 116 - 125
        case let x where x > 115:
            setWarning(warning: "You shall not pass! ✋")
            setDismiss(message: "Thanks, Gandalf 😐")
            break
            
        // 101 - 115
        case let x where x > 100:
            setWarning(warning: "Is there extra credit? 😬")
            setDismiss(message: "I'll look into that 🙄")
            break
            
        // 100
        case let x where x == 100:
            setWarning(warning: "May the Force be with you...")
            setDismiss(message: "Thank you, Master 🙏")
            break
            
        // 90 - 99
        case let x where x >= 90:
            setWarning(warning: "I have faith in you.")
            setDismiss(message: "Thanks bro 😅")
            break
            
        // 80 - 89
        case let x where x >= 80:
            setWarning(warning: "You got this.")
            setDismiss(message: "It's possible 🤔")
            break
            
        // 70 - 79
        case let x where x >= 70:
            setWarning(warning: "Not so bad.")
            setDismiss(message: "Alright 😛")
            break
            
        // 60 - 69
        case let x where x >= 60:
            setWarning(warning: "Piece o' cake.")
            setDismiss(message: "Yes please 🍰")
            break
            
        // 50 - 59
        case let x where x >= 50:
            setWarning(warning: "No problemo.")
            setDismiss(message: "I can do that 😃")
            break
            
        // 1 - 49
        case let x where x > 0:
            setWarning(warning: "You could bomb it.")
            setDismiss(message: "Chill 👌")
            break
            
        // <= 0
        case let x where x <= 0:
            setWarning(warning: "Don't even take the test, dude.")
            setDismiss(message: "Sweeeet 😎")
            break
            
        default: break
        }
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo])   / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}