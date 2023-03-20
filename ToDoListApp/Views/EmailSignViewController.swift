//
//  EmailSignViewController.swift
//  ToDoListApp
//
//  Created by Mac on 17.03.2023.
//

import UIKit

class EmailSignViewController: UIViewController {
    
    public weak var loginDelegate: LoginViewDelagate?
    private let emailPresenter = EmailSignPresenter()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter you email..."
        textField.text = "1@2.com"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter you password..."
        textField.text = "123456"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.frame = CGRect()
        button.setTitle("Sign in", for: .normal)
        button.addTarget(self, action: #selector(signInClicked), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.backgroundColor = .gray
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        emailPresenter.setDelegate(delegate: self)
    }

    private func initUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
        ])
    }

    @objc private func signInClicked() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            emailPresenter.signIn(email: email, password: password)
        } else {
            errorSignIn(message: "Something wrong with email or password...")
        }
    }
}

// MARK: - Email sign in delegate functions

extension EmailSignViewController: EmailSignDelegate {
    func didSignIn(user: User) {
        loginDelegate?.didSignInSuccessfully(user: user)
        dismiss(animated: true)
    }

    func errorSignIn(message: String) {
        let alert = UIAlertController(title: "Sign in error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}
