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

protocol LoginViewDelagate: AnyObject {
    func didSignInSuccessfully(user: User)
}

class LoginViewController: UIViewController {
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

extension UIView {
    public var viewWidth: CGFloat {
        return frame.size.width
    }

    public var viewHeight: CGFloat {
        return frame.size.height
    }
}

// MARK: - Sign in methods

extension LoginViewController {
    @objc fileprivate func signInWithApple() {
        let alert = UIAlertController(title: "Apple sign in", message: "Apple sign in will be implement as soon as possible!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }

    @objc fileprivate func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else { return }

                if let result = result {
                    print(result.user.userID!)
                    // go to another scene
                }
            }
        }
    }

    @objc fileprivate func sighInWithEmail() {
        let viewControllerToPresent = EmailSignViewController()
        viewControllerToPresent.loginDelegate = self
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        navigationController?.present(viewControllerToPresent, animated: true)
    }
}

extension LoginViewController: LoginViewDelagate {
    func didSignInSuccessfully(user: User) {
        let todoVC = TodoViewController()
        todoVC.user = user
        navigationController?.pushViewController(todoVC, animated: true)
    }
}
