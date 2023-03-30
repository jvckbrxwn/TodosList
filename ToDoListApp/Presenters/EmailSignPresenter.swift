//
//  EmailSignPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import FirebaseAuth
import UIKit

protocol EmailSignDelegate: BasePresenterDelegate {
    func didSignIn(user: User)
    func errorSignIn(message: String)
}

class EmailSignPresenter: BasePresenter {
    internal func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] data, error in
            if let safeData = data, error == nil {
                DispatchQueue.main.async {
                    let user = User(name: safeData.user.uid, email: safeData.user.email!)
                    (self?.delegate as? EmailSignDelegate)?.didSignIn(user: user)
                }
            } else {
                if let safeError = error {
                    (self?.delegate as? EmailSignDelegate)?.errorSignIn(message: safeError.localizedDescription)
                }
            }
        }
    }
}
