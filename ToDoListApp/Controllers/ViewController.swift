//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Mac on 16.03.2023.
//

import FirebaseAuth
import UIKit

enum SignInType {
    case email, apple, google
}

struct UIButtonSettings {
}

class ViewController: UIViewController {
    private var signInWithAppleButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .large
        configuration.imagePadding = 10
        configuration.background.backgroundColor = .black
        let button = UIButton(configuration: configuration)
        button.setTitle("Sign in with Apple", for: .normal)
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private var signInWithGoogleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .large
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.setTitle("Sign in with Google", for: .normal)
        button.setImage(UIImage(systemName: "circle.hexagonpath.fill"), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private var signInWithEmailButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .large
        let button = UIButton(configuration: configuration)
        button.setTitle("Sign in with email", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private var stackViewForButtons: UIStackView = {
        let stuckView = UIStackView()
        stuckView.translatesAutoresizingMaskIntoConstraints = false
        return stuckView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initUI()
    }

    private func initUI() {
        signInWithAppleButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        signInWithGoogleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        signInWithEmailButton.addTarget(self, action: #selector(sighInWithEmail), for: .touchUpInside)

        stackViewForButtons.distribution = .fillEqually
        stackViewForButtons.axis = .vertical
        stackViewForButtons.spacing = 5
        stackViewForButtons.addSubviewInside([signInWithAppleButton, signInWithGoogleButton, signInWithEmailButton])
        view.addSubview(stackViewForButtons)

        stackViewForButtons.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackViewForButtons.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackViewForButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        stackViewForButtons.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    private func setSettings(to button: UIButton, settings: UIButtonSettings) {
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

extension UIStackView {
    public func addSubviewInside(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}

// MARK: - Sign in methods

extension ViewController {
    @objc fileprivate func signInWithApple() {
        let alert = UIAlertController(title: "Apple sign in", message: "Apple sign in will be implement as soon as possible!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }

    @objc fileprivate func signInWithGoogle() {
        print("signInWithGoogle is called")
    }

    @objc fileprivate func sighInWithEmail() {
        print("sighInWithEmail is called")
    }
}
