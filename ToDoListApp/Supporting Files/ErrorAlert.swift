//
//  ErrorAlertViewController.swift
//  ToDoListApp
//
//  Created by Mac on 03.04.2023.
//

import UIKit

class ErrorAlert {
    static let shared = ErrorAlert()

    private lazy var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    private init() {
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
    }

    func show(title: String, errorMessage: String, _ prefferedStyle: UIAlertController.Style = .alert) -> UIAlertController {
        alert.title = title
        alert.message = errorMessage
        return alert
    }
}
