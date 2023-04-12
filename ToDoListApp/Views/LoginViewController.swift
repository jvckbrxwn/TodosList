//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Mac on 16.03.2023.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

class LoginViewController: UIViewController {
    private lazy var loginPresenter: LoginPresenter = LoginPresenter()
    private lazy var secondaryFont = UIBuilder.getFont(type: .secondary, withSize: 14)
    private lazy var errorFont = UIBuilder.getFont(type: .error, withSize: 8)
    private lazy var mainFont = UIBuilder.getFont(type: .main, withSize: 14)

    private lazy var welcomeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        var welcomeLabel = UIBuilder.getLabel(set: UILabelSettings(font: UIBuilder.getFont(type: .main, withSize: 22), text: "Welcome to Todo List,\nSign in to Continue."))
        var dontHaveAccLabel = UIBuilder.getLabel(set: UILabelSettings(font: secondaryFont, text: "Don't have an account?"))
        var itTakesLabel = UIBuilder.getLabel(set: UILabelSettings(font: secondaryFont, text: "It takes less than a minute"))

        let createAccountButton = UIBuilder.getButton(set: UIButtonSettings(font: secondaryFont, title: "Create an account", titleColor: UIColor(named: "AccentColor"), action: #selector(createAcconut)))

        view.addSubview(welcomeLabel)
        view.addSubview(dontHaveAccLabel)
        view.addSubview(itTakesLabel)
        view.addSubview(createAccountButton)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 140),

            // welcome label
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor, constant: 5),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 65),

            // dont have acc label
            dontHaveAccLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            dontHaveAccLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            dontHaveAccLabel.heightAnchor.constraint(equalToConstant: 20),

            // create acc button
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.leadingAnchor.constraint(equalTo: dontHaveAccLabel.trailingAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 20),
            createAccountButton.widthAnchor.constraint(equalToConstant: 120),

            // it takes label
            itTakesLabel.topAnchor.constraint(equalTo: dontHaveAccLabel.bottomAnchor),
            itTakesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            itTakesLabel.heightAnchor.constraint(equalToConstant: 20),
        ])

        return view
    }()

    private lazy var emailTextField: UITextField = UIBuilder.getTextField(set: UITextFieldSettings(type: .emailAddress, keyboardType: .emailAddress))

    private lazy var emailErrorLabel: UILabel = UIBuilder.getLabel(set: UILabelSettings(font: errorFont, textColor: UIColor.red))

    private lazy var passwordTextField: UITextField = UIBuilder.getTextField(set: UITextFieldSettings(type: .password, isSecureTextEntry: true))

    private lazy var passwordErrorLabel: UILabel = UIBuilder.getLabel(set: UILabelSettings(font: errorFont, textColor: UIColor.red))

    private lazy var textFieldsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let emailLabel = UIBuilder.getLabel(set: UILabelSettings(font: mainFont, text: "Email"))
        let passwordLabel = UIBuilder.getLabel(set: UILabelSettings(font: mainFont, text: "Password"))

        let forgotPasswordButton = UIBuilder.getButton(set: UIButtonSettings(type: .system, font: secondaryFont, title: "Forgot password?", titleColor: UIColor(named: "AccentColor"), action: #selector(forgotPassword)))

        emailTextField.font = secondaryFont
        passwordTextField.font = secondaryFont
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorLabel)
        view.addSubview(forgotPasswordButton)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 160),

            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),

            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailErrorLabel.trailingAnchor, constant: 5),
            emailErrorLabel.heightAnchor.constraint(equalToConstant: 10),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),

            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordErrorLabel.trailingAnchor, constant: 5),
            passwordErrorLabel.heightAnchor.constraint(equalToConstant: 10),

            view.bottomAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor),
            view.trailingAnchor.constraint(lessThanOrEqualTo: forgotPasswordButton.trailingAnchor, constant: 100),
            forgotPasswordButton.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: 100),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),
        ])

        return view
    }()

    private lazy var buttonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let signInButton = UIBuilder.getButton(set: UIButtonSettings(font:  UIBuilder.getFont(type: .main, withSize: 22), title: "Sign In", titleColor: nil, action: #selector(sighInWithEmail)))
        signInButton.configuration = .filled()
        signInButton.tintColor = UIColor(named: "AccentColor")

        let googleSignInButton = UIBuilder.getButton(set: UIButtonSettings(font:  UIBuilder.getFont(type: .main, withSize: 22), title: "Sign In with Google", titleColor: UIColor.label, action: #selector(signInWithGoogle)))
        googleSignInButton.configuration = .gray()
        googleSignInButton.setImage(UIImage(named: "google.png"), for: .normal)
        googleSignInButton.configuration?.imagePadding = 10

        view.addSubview(signInButton)
        view.addSubview(googleSignInButton)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 120),

            signInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor, constant: 5),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            googleSignInButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: googleSignInButton.trailingAnchor, constant: 5),
            googleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
        ])

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        initUI()
        // initKeyboardShowState()
    }

    override func viewDidAppear(_ animated: Bool) {
        loginPresenter.checkIfUserLoggedIn()
    }

    private func initUI() {
        view.backgroundColor = .systemBackground
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        view.addSubview(welcomeView)
        view.addSubview(textFieldsView)
        view.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            // welcome view
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor, constant: 20),
            welcomeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            welcomeView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -140),

            // text fields view
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textFieldsView.trailingAnchor, constant: 20),
            textFieldsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldsView.topAnchor.constraint(equalTo: welcomeView.bottomAnchor, constant: 5),

            // buttons view
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: 20),
            buttonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsView.topAnchor.constraint(equalTo: textFieldsView.bottomAnchor, constant: 30),
        ])
    }
}

// MARK: - Sign in methods

extension LoginViewController {
    @objc private func sighInWithEmail() {
        let emailValidationResult = Validator.shared.validate(email: emailTextField.text!)
        let passwordValidationResult = Validator.shared.validate(password: passwordTextField.text!)

        if !emailValidationResult.state {
            emailErrorLabel.text = emailValidationResult.message!
            emailTextField.setError()
        }

        if !passwordValidationResult.state {
            passwordErrorLabel.text = passwordValidationResult.message!
            passwordTextField.setError()
        }

        if !emailValidationResult.state || !passwordValidationResult.state {
            return
        }

        let email = emailTextField.text!
        let password = passwordTextField.text!
        loginPresenter.signInWithEmail(email, password)
    }

    @objc private func signInWithGoogle() {
        loginPresenter.signInWithGoogle()
    }

    // TODO: JUST DO IT!
    @objc private func forgotPassword() {
        present(ErrorAlert.shared.show(title: "Coming soon...", errorMessage: "Forgot password is not ready for now"), animated: true)
    }

    @objc private func createAcconut() {
        let registrationVC = RegistrationViewController()
        registrationVC.delegate = self
        let registrationNav = UINavigationController(rootViewController: registrationVC)
        if let sheet = registrationNav.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { _ in 350 }]
            } else {
                sheet.detents = [.medium()]
            }
        }
        present(registrationNav, animated: true)
    }
}

// MARK: - Login View Delagate functions

extension LoginViewController: LoginViewDelagate {
    func signInError(message: String) {
        let alert = ErrorAlert.shared.show(title: "Sign in error", errorMessage: message)
        present(alert, animated: true)
    }

    func didSignInSuccessfully(user: User) {
        UserManager.shared.currentUser = user
        let todoVC = TodoViewController()
        navigationController?.pushViewController(todoVC, animated: true)
    }
}

// TODO: find another way to communicate between views
extension LoginViewController: RegistrationViewControllerDelegate {
    func didRegisterSuccessfully(user: User) {
        didSignInSuccessfully(user: user)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.clearError()
        if textField.textContentType == .emailAddress {
            emailErrorLabel.text = ""
        } else if textField.textContentType == .password {
            passwordErrorLabel.text = ""
        }
        return true
    }
}
