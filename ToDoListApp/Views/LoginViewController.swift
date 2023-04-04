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

    private lazy var welcomeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        var welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to Todo List,\nSign in to Continue."
        welcomeLabel.font = UIFont(name: "Avenir Heavy", size: 22)
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true

        var dontHaveAccLabel = UILabel()
        dontHaveAccLabel.text = "Don't have an account?"
        dontHaveAccLabel.font = UIFont(name: "Avenir Book", size: 14)
        dontHaveAccLabel.translatesAutoresizingMaskIntoConstraints = false
        dontHaveAccLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        var itTakesLabel = UILabel()
        itTakesLabel.text = "It takes less than a minute"
        itTakesLabel.font = UIFont(name: "Avenir Book", size: 14)
        itTakesLabel.translatesAutoresizingMaskIntoConstraints = false
        itTakesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let createAccountButton = UIButton(type: .system)
        createAccountButton.titleLabel?.font = UIFont(name: "Avenir Book", size: 14)
        createAccountButton.setTitle("Create an account", for: .normal)
        createAccountButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        createAccountButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        createAccountButton.addTarget(self, action: #selector(createAcconut), for: .touchUpInside)

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

            // dont have acc label
            dontHaveAccLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            dontHaveAccLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),

            // create acc button
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.leadingAnchor.constraint(equalTo: dontHaveAccLabel.trailingAnchor),

            // it takes label
            itTakesLabel.topAnchor.constraint(equalTo: dontHaveAccLabel.bottomAnchor),
            itTakesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
        ])

        return view
    }()

    private lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textContentType = .emailAddress
        field.keyboardType = .emailAddress
        field.borderStyle = .roundedRect
        return field
    }()

    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textContentType = .password
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private lazy var textFieldsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont(name: "Avenir Heavy", size: 14)

        let passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: "Avenir Heavy", size: 14)

        let forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.titleLabel?.font = UIFont(name: "Avenir Book", size: 14)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)

        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordButton)

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 160),

            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),

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

        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.tintColor = UIColor(named: "AccentColor")
        signInButton.addTarget(nil, action: #selector(sighInWithEmail), for: .touchUpInside)

        let googleSignInButton = UIButton()
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.configuration = .gray()
        googleSignInButton.setTitle("Sign In with Google", for: .normal)
        googleSignInButton.setTitleColor(UIColor.label, for: .normal)
        googleSignInButton.setImage(UIImage(named: "google.png"), for: .normal)
        googleSignInButton.configuration?.imagePadding = 10
        googleSignInButton.addTarget(nil, action: #selector(signInWithGoogle), for: .touchUpInside)

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
        initUI()
        initKeyboardShowState()
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

    private func initKeyboardShowState() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}

// MARK: - Kayboard showing methods (test version)

extension LoginViewController {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

// MARK: - Sign in methods

extension LoginViewController {
    @objc private func sighInWithEmail() {
        if Validator.shared.validate(email: emailTextField.text!) == false {
            // TODO: temporary version
            let alert = ErrorAlert.shared.show(title: "Internal error", errorMessage: "Email is not valid")
            present(alert, animated: true)
            // emailTextField.setError(errorLabel: emailErrorLabel, message: "Email is not valid")
            return
        }
        if Validator.shared.validate(password: passwordTextField.text!) == false {
            // TODO: temporary version
            let alert = ErrorAlert.shared.show(title: "Internal error", errorMessage: "Password cannot be empty")
            present(alert, animated: true)
            // passwordTextField.setError(errorLabel: passwordErrorLabel, message: "Password cannot be empty")
            return
        }

        let email = emailTextField.text!
        let password = passwordTextField.text!
        loginPresenter.signInWithEmail(email: email, password: password)
    }

    @objc private func signInWithGoogle() {
        loginPresenter.signInWithGoogle()
    }

    // TODO: JUST DO IT!
    @objc private func forgotPassword() {
        present(ErrorAlert.shared.show(title: "Coming soon...", errorMessage: "Forgot password is not ready for now"), animated: true)
    }

    // TODO: JUST DO IT!
    @objc private func createAcconut() {
        present(ErrorAlert.shared.show(title: "Coming soon...", errorMessage: "Create account is not ready for now"), animated: true)
    }
}

extension LoginViewController: LoginViewDelagate {
    func signInError(message: String) {
        let alert = ErrorAlert.shared.show(title: "Sign in error", errorMessage: message)
        present(alert, animated: true)
    }

    func didSignInSuccessfully(user: User) {
        UserManager.shared.setUser(user: user)
        let todoVC = TodoViewController()
        navigationController?.pushViewController(todoVC, animated: true)
    }
}

// MARK: - Simple helpers

extension LoginViewController {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
