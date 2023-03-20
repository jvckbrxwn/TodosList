//
//  EmailSignPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import FirebaseAuth
import UIKit

protocol EmailSignDelegate: AnyObject {
    func didSignIn(user: User)
    func errorSignIn(message: String)
}

typealias PresenterDelegate = EmailSignDelegate & UIViewController

class EmailSignPresenter {
    private weak var emailDelagate: PresenterDelegate?

    public func setDelegate(delegate: PresenterDelegate) {
        emailDelagate = delegate
    }

    public func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] data, error in
            if let safeData = data, error == nil {
                DispatchQueue.main.async {
                    let user = User(name: safeData.user.uid, email: safeData.user.email!)
                    self?.emailDelagate?.didSignIn(user: user)
                }
            } else {
                if let safeError = error {
                    DispatchQueue.main.async {
                        self?.emailDelagate?.errorSignIn(message: safeError.localizedDescription)
                    }
                }
            }
        }
    }
}
