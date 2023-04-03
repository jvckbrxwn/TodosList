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
    private lazy var emailVC = EmailSignViewController()
    private lazy var emailSheetNav = UINavigationController(rootViewController: emailVC)

    private lazy var signInWithAppleButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .large
        configuration.imagePadding = 10
        configuration.background.backgroundColor = .black
        let button = UIButton(configuration: configuration)
        button.setTitle("Sign in with Apple", for: .normal)
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        return button
    }()

    private lazy var signInWithGoogleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .large
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.setTitle("Sign in with Google", for: .normal)
        button.setImage(UIImage(systemName: "circle.hexagonpath.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        return button
    }()

    private lazy var signInWithEmailButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .large
        let button = UIButton(configuration: configuration)
        button.setTitle("Sign in with email", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sighInWithEmail), for: .touchUpInside)
        return button
    }()

    private lazy var stackViewForButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signInWithAppleButton, signInWithGoogleButton, signInWithEmailButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loginPresenter.delegate = self
        emailVC.loginDelegate = self
        initUI()
    }

    private func initUI() {
        view.addSubview(stackViewForButtons)

        NSLayoutConstraint.activate([
            stackViewForButtons.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackViewForButtons.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackViewForButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackViewForButtons.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - Sign in methods

extension LoginViewController {
    @objc fileprivate func signInWithApple() {
        let alert = ErrorAlert.shared.show(title: "Apple sign in", errorMessage: "Apple sign in will be implement as soon as possible!")
        present(alert, animated: true)
    }

    @objc fileprivate func sighInWithEmail() {
        if let sheet = emailVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(emailVC, animated: true)
    }

    @objc fileprivate func signInWithGoogle() {
        loginPresenter.signInWithGoogle()
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
