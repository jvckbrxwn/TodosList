//
//  RegistrationViewController.swift
//  ToDoListApp
//
//  Created by Mac on 05.04.2023.
//

import UIKit

protocol RegistrationViewControllerDelegate: AnyObject {
    func didRegisterSuccessfully(user: User)
}

class RegistrationViewController: UIViewController {
    internal weak var delegate: RegistrationViewControllerDelegate?

    private lazy var registrationPresetner = RegistrationPresenter()
    private lazy var mainFont = UIBuilder.getFont(type: .main, withSize: 14)
    private lazy var secondaryFont = UIBuilder.getFont(type: .secondary, withSize: 14)
    private lazy var errorFont = UIBuilder.getFont(type: .error, withSize: 8)
    
    private lazy var emailErrorLabel = UIBuilder.getLabel(set: UILabelSettings(font: errorFont, textColor: .red))
    private lazy var passwordErrorLabel = UIBuilder.getLabel(set: UILabelSettings(font: errorFont, textColor: .red))
    private lazy var confirmErrorLabel = UIBuilder.getLabel(set: UILabelSettings(font: errorFont, textColor: .red))

    private lazy var emailTextField = UIBuilder.getTextField(set: UITextFieldSettings(type: .emailAddress, keyboardType: .emailAddress, borderStyle: .roundedRect))
    private lazy var passwordTextField = UIBuilder.getTextField(set: UITextFieldSettings(type: .password, borderStyle: .roundedRect, isSecureTextEntry: true))
    private lazy var confirmTextField = UIBuilder.getTextField(set: UITextFieldSettings(type: .password, borderStyle: .roundedRect, isSecureTextEntry: true))

    private lazy var registarionView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground

        let emailLabel = UIBuilder.getLabel(set: UILabelSettings(font: mainFont, text: "Email"))
        let passwordLabel = UIBuilder.getLabel(set: UILabelSettings(font: mainFont, text: "Password"))
        let confirmLabel = UIBuilder.getLabel(set: UILabelSettings(font: mainFont, text: "Confirm password"))

        let submitButton = UIBuilder.getButton(set: UIButtonSettings(font: mainFont, title: "Submit", titleColor: nil, action: #selector(registration)))
        submitButton.configuration = .filled()
        submitButton.tintColor = UIColor(named: "AccentColor")

        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorLabel)
        view.addSubview(confirmLabel)
        view.addSubview(confirmTextField)
        view.addSubview(confirmErrorLabel)
        view.addSubview(submitButton)

        emailTextField.font = secondaryFont
        emailTextField.accessibilityIdentifier = "email"
        
        passwordTextField.font = secondaryFont
        passwordTextField.accessibilityIdentifier = "password"
        
        confirmTextField.font = secondaryFont
        confirmTextField.accessibilityIdentifier = "confirm"

        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),

            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailErrorLabel.trailingAnchor, constant: 5),
            emailErrorLabel.heightAnchor.constraint(equalToConstant: 10),

            passwordLabel.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 5),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            passwordLabel.heightAnchor.constraint(equalToConstant: 20),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),

            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordErrorLabel.trailingAnchor, constant: 5),
            passwordErrorLabel.heightAnchor.constraint(equalToConstant: 10),

            confirmLabel.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 5),
            confirmLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            confirmLabel.heightAnchor.constraint(equalToConstant: 20),

            confirmTextField.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor),
            confirmTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: confirmTextField.trailingAnchor, constant: 5),
            confirmTextField.heightAnchor.constraint(equalToConstant: 35),

            confirmErrorLabel.topAnchor.constraint(equalTo: confirmTextField.bottomAnchor),
            confirmErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: confirmErrorLabel.trailingAnchor, constant: 5),
            confirmErrorLabel.heightAnchor.constraint(equalToConstant: 10),

            submitButton.topAnchor.constraint(equalTo: confirmErrorLabel.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 5),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        registrationPresetner.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        initUI()
    }

    private func initUI() {
        title = "Register"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
        view.addSubview(registarionView)

        NSLayoutConstraint.activate([
            registarionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registarionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: registarionView.trailingAnchor, constant: 20),
            registarionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc private func registration() {
        let emailValidationResult = Validator.shared.validate(email: emailTextField.text!)
        let passwordValidationResult = Validator.shared.validate(password: passwordTextField.text!)
        let confirmValidationResult = Validator.shared.validate(password: passwordTextField.text!, confirmPassword: confirmTextField.text!)

        if !emailValidationResult.state {
            emailErrorLabel.text = emailValidationResult.message
            emailTextField.setError()
        }

        if !passwordValidationResult.state {
            passwordErrorLabel.text = passwordValidationResult.message
            passwordTextField.setError()
        }

        if !confirmValidationResult.state {
            confirmErrorLabel.text = confirmValidationResult.message
            confirmTextField.setError()
        }

        if !emailValidationResult.state || !passwordValidationResult.state || !confirmValidationResult.state {
            return
        }

        registrationPresetner.register(emailTextField.text!, passwordTextField.text!)
    }

    @objc private func dismissView() {
        view.endEditing(true)
        dismiss(animated: true)
    }
}

// MARK: - Registration presenter delegate methods

extension RegistrationViewController: RegistrationPresenterDelegate {
    func didRegisterSuccessfully(user: User) {
        delegate?.didRegisterSuccessfully(user: user)
        dismissView()
    }

    func didRegisterError(message: String) {
        let alert = ErrorAlert.shared.show(title: "Registration error", errorMessage: message)
        present(alert, animated: true)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.accessibilityIdentifier == "email" {
            emailErrorLabel.text = ""
        } else if textField.accessibilityIdentifier == "password" {
            passwordErrorLabel.text = ""
        } else if textField.accessibilityIdentifier == "confirm" {
            confirmErrorLabel.text = ""
        }
        textField.clearError()
        return true
    }
}
