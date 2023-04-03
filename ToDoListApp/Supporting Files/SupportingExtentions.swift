//
//  SupportingExtentions.swift
//  ToDoListApp
//
//  Created by Mac on 30.03.2023.
//

import UIKit

extension UITextField {
    func setError(errorLabel label: UILabel, message: String) {
        // show redborder and small label that email is not valid
        
        let borderColorAnim = CAKeyframeAnimation(keyPath: "borderColor")
        borderColorAnim.duration = 0.5
        borderColorAnim.values = [UIColor.clear.cgColor, UIColor.red.cgColor]
        borderColorAnim.repeatCount = 1
        layer.add(borderColorAnim, forKey: "borderColor")
        layer.borderColor = UIColor.red.cgColor

        let borderWidthAnim = CAKeyframeAnimation(keyPath: "borderWidth")
        borderWidthAnim.duration = 0.5
        borderWidthAnim.values = [0, 1]
        borderWidthAnim.repeatCount = 1
        layer.add(borderWidthAnim, forKey: "borderWidth")
        layer.borderWidth = 1

        label.text = message
    }

    func clearError() {
        let borderColorAnim = CAKeyframeAnimation(keyPath: "borderColor")
        borderColorAnim.duration = 0.5
        borderColorAnim.values = [UIColor.red.cgColor, UIColor.clear.cgColor]
        layer.add(borderColorAnim, forKey: "borderColor")
        layer.borderColor = UIColor.clear.cgColor

        let borderWidthAnim = CAKeyframeAnimation(keyPath: "borderWidth")
        borderWidthAnim.duration = 0.5
        borderWidthAnim.values = [1, 0]
        layer.add(borderWidthAnim, forKey: "borderWidth")
        layer.borderWidth = 0
    }
}
