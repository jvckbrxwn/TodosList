//
//  UITemplatesManager.swift
//  ToDoListApp
//
//  Created by Mac on 10.04.2023.
//

import UIKit

struct UILabelSettings {
    let font: UIFont?
    let text: String
    let textColor: UIColor?

    init(font: UIFont?, text: String = "", textColor: UIColor? = UIColor.label) {
        self.font = font
        self.text = text
        self.textColor = textColor
    }
}

struct UIButtonSettings {
    let type: UIButton.ButtonType
    let font: UIFont?
    let title: String
    let titleColor: UIColor?
    let action: Selector

    init(type: UIButton.ButtonType = .system, font: UIFont?, title: String, titleColor: UIColor?, action: Selector) {
        self.type = type
        self.font = font
        self.title = title
        self.titleColor = titleColor
        self.action = action
    }
}

struct UITextFieldSettings {
    let type: UITextContentType?
    let keyboardType: UIKeyboardType
    let borderStyle: UITextField.BorderStyle
    let autocapitalization: UITextAutocapitalizationType
    let isSecureTextEntry: Bool
    let placeholder: String

    init(type: UITextContentType? = nil, keyboardType: UIKeyboardType = .default, borderStyle: UITextField.BorderStyle = .roundedRect, autocapitalization: UITextAutocapitalizationType = .none, isSecureTextEntry: Bool = false, placeholder: String = "") {
        self.type = type
        self.keyboardType = keyboardType
        self.borderStyle = borderStyle
        self.autocapitalization = autocapitalization
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
    }
}

struct UIBuilder {
    static func getLabel(set settings: UILabelSettings) -> UILabel {
        let label = UILabel()
        label.text = settings.text
        label.textColor = settings.textColor
        label.font = settings.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func getButton(set settings: UIButtonSettings) -> UIButton {
        let button = UIButton(type: settings.type)
        button.titleLabel?.font = settings.font
        button.setTitle(settings.title, for: .normal)
        button.setTitleColor(settings.titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: settings.action, for: .touchUpInside)
        return button
    }

    static func getTextField(set settings: UITextFieldSettings) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textContentType = settings.type
        field.keyboardType = settings.keyboardType
        field.borderStyle = settings.borderStyle
        field.autocapitalizationType = settings.autocapitalization
        field.placeholder = settings.placeholder
        return field
    }
}
