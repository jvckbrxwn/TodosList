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
    private lazy var mainFont = UIFont(name: "Avenir Heavy", size: 14)
    private lazy var secondaryFont = UIFont(name: "Avenir Book", size: 14)
    private lazy var registrationPresetner = RegistrationPresenter()
    internal weak var delegate: RegistrationViewControllerDelegate?

    private lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.font = secondaryFont
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textContentType = .emailAddress
        field.keyboardType = .emailAddress
        field.borderStyle = .roundedRect
        return field
    }()

    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.font = secondaryFont
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textContentType = .password
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private lazy var confirmTextField: UITextField = {
        let field = UITextField()
        field.font = secondaryFont
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textContentType = .password
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private lazy var registarionView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground

        let emailLabel = UILabel()
        emailLabel.font = mainFont
        emailLabel.text = "Email"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        let passwordLabel = UILabel()
        passwordLabel.font = mainFont
        passwordLabel.text = "Password"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false

        let confirmLabel = UILabel()
        confirmLabel.font = mainFont
        confirmLabel.text = "Confirm password"
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false

        let submitButton = UIButton()
        submitButton.configuration = .filled()
        submitButton.titleLabel?.font = mainFont
        submitButton.setTitle("Submit", for: .normal)
        submitButton.tintColor = UIColor(named: "AccentColor")
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(registration), for: .touchUpInside)

        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmLabel)
        view.addSubview(confirmTextField)
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            passwordLabel.heightAnchor.constraint(equalToConstant: 20),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),

            confirmLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            confirmLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            confirmLabel.heightAnchor.constraint(equalToConstant: 20),

            confirmTextField.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor),
            confirmTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: confirmTextField.trailingAnchor, constant: 5),
            confirmTextField.heightAnchor.constraint(equalToConstant: 35),

            submitButton.topAnchor.constraint(equalTo: confirmTextField.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 5),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        registrationPresetner.delegate = self
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
            emailTextField.setError()
        }
        
        if !passwordValidationResult.state {
            passwordTextField.setError()
        }
        
        if !confirmValidationResult.state {
            confirmTextField.setError()
        }
        
        if !emailValidationResult.state || !passwordValidationResult.state || !confirmValidationResult.state {
            return
        }
        
        // TODO: change to normal state of textField when we start typing or smth similar
        emailTextField.clearError()
        passwordTextField.clearError()
        confirmTextField.clearError()

        registrationPresetner.register(emailTextField.text!, passwordTextField.text!)
    }

    @objc private func dismissView() {
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
