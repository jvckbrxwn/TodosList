//
//  EmailSignViewController.swift
//  ToDoListApp
//
//  Created by Mac on 17.03.2023.
//

import UIKit

class EmailSignViewController: UIViewController {
    internal weak var loginDelegate: LoginViewDelagate?
    private let emailPresenter = EmailSignPresenter()

    private var wasEmailError: Bool = false // TODO: Change it asap. Too bad idea
    private var wasPasswordError: Bool = false // TODO: Change it asap. Too bad idea

    private let emailTextFieldIdentifier = "emailTextField"
    private let passwordTextFieldIdentifier = "passwordTextField"

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        return label
    }()

    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.font = label.font.withSize(10)
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email..."
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.accessibilityIdentifier = emailTextFieldIdentifier
        textField.layer.cornerRadius = 5
        return textField
    }()

    private lazy var emailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailErrorLabel)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 115),

            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.heightAnchor.constraint(equalToConstant: 30),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailErrorLabel.trailingAnchor, constant: 20),
            emailErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailErrorLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
        return view
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        return label
    }()

    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(10)
        label.textColor = UIColor.red
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter you password..."
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.accessibilityIdentifier = passwordTextFieldIdentifier
        textField.layer.cornerRadius = 5
        return textField
    }()

    private lazy var passwordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorLabel)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 115),

            passwordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 20),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordErrorLabel.trailingAnchor, constant: 20),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordErrorLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
        return view
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Sign in", for: .normal)
        button.addTarget(self, action: #selector(signInClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 150),
        ])
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailPresenter.setDelegate(delegate: self)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        initUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if wasEmailError {
            emailTextField.clearError()
            emailErrorLabel.text = ""
            wasEmailError = false
        }

        if wasPasswordError {
            passwordTextField.clearError()
            passwordErrorLabel.text = ""
            wasPasswordError = false
        }
    }

    private func initUI() {
        title = "Sign in"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(hideView))
        view.backgroundColor = .systemBackground
        view.addSubview(emailView)
        view.addSubview(passwordView)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            emailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: emailView.trailingAnchor),

            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor),
            passwordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 10),
        ])
    }

    @objc private func signInClicked() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)

        if Validator.shared.validate(email: emailTextField.text!) == false {
            wasEmailError = true
            emailTextField.setError(errorLabel: emailErrorLabel, message: "Email is not valid")
            return
        }
        if Validator.shared.validate(password: passwordTextField.text!) == false {
            wasPasswordError = true
            passwordTextField.setError(errorLabel: passwordErrorLabel, message: "Password cannot be empty")
            return
        }

        let email = emailTextField.text!
        let password = passwordTextField.text!
        emailPresenter.signIn(email: email, password: password)
    }

    @objc private func hideView() {
        dismiss(animated: true)
    }
}

// MARK: - Email sign in delegate functions

extension EmailSignViewController: EmailSignDelegate {
    func didSignIn(user: User) {
        loginDelegate?.didSignInSuccessfully(user: user)
        dismiss(animated: true)
    }

    func errorSignIn(message: String) {
        let alert = ErrorAlert.shared.show(title: "Sign in error", errorMessage: message)
        present(alert, animated: true)
    }
}

extension EmailSignViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.accessibilityIdentifier {
        case emailTextFieldIdentifier:
            if wasEmailError {
                textField.clearError()
                emailErrorLabel.text = ""
                wasEmailError = false
            }
        case passwordTextFieldIdentifier:
            if wasPasswordError {
                textField.clearError()
                passwordErrorLabel.text = ""
                wasPasswordError = false
            }
        default:
            let alert = ErrorAlert.shared.show(title: "Internal error", errorMessage: "WUUUT ur u doing?")
            present(alert, animated: true)
        }
    }
}
