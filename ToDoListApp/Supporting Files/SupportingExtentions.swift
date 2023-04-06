//
//  SupportingExtentions.swift
//  ToDoListApp
//
//  Created by Mac on 30.03.2023.
//

import UIKit

extension UITextField {
    func setError() {
        errorAnimation()
    }

    func setError(errorLabel label: UILabel, message: String) {
        // show redborder and small label that email is not valid
        errorAnimation()
        label.text = message
    }

    func clearError() {
        errorColorAimationFade(key: "borderColor", from: UIColor.red.cgColor, to: UIColor.clear.cgColor)
        errorBorderAimationFade(key: "borderWidth", from: 1, to: 0)
    }

    private func errorAnimation() {
        errorColorAimationFade(key: "borderColor", from: UIColor.clear.cgColor, to: UIColor.red.cgColor)
        errorBorderAimationFade(key: "borderWidth", from: 0, to: 1)
    }

    private func errorColorAimationFade(key: String, from startColor: CGColor, to endColor: CGColor, duration: Double = 0.3) {
        guard layer.borderColor != endColor else { return }

        let borderColorAnim = CAKeyframeAnimation(keyPath: key)
        borderColorAnim.duration = duration
        borderColorAnim.values = [startColor, endColor]
        borderColorAnim.repeatCount = 1
        layer.add(borderColorAnim, forKey: key)
        layer.borderColor = endColor
    }

    private func errorBorderAimationFade(key: String, from startValue: Float, to endValue: Float, duration: Double = 0.3) {
        guard layer.borderWidth != CGFloat(endValue) else { return }

        let borderWidthAnim = CAKeyframeAnimation(keyPath: key)
        borderWidthAnim.duration = duration
        borderWidthAnim.values = [startValue, endValue]
        borderWidthAnim.repeatCount = 1
        layer.add(borderWidthAnim, forKey: key)
        layer.borderWidth = CGFloat(endValue)
    }
}
