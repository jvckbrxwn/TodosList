//
//  LoginViewPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 21.03.2023.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

protocol LoginViewDelagate: BasePresenterDelegate {
    func didSignInSuccessfully(user: User)
    func signInError(message: String)
}

class LoginPresenter: BasePresenter {
    internal func checkIfUserLoggedIn() {
        if let currentUser = Auth.auth().currentUser {
            let user = User(name: currentUser.uid, email: currentUser.email!)
            (delegate as? LoginViewDelagate)?.didSignInSuccessfully(user: user)
        }
    }

    internal func signInWithEmail(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] data, error in
            if let safeData = data, error == nil {
                let user = User(name: safeData.user.uid, email: safeData.user.email!)
                (self?.delegate as? LoginViewDelagate)?.didSignInSuccessfully(user: user)

            } else {
                if let safeError = error {
                    (self?.delegate as? LoginViewDelagate)?.signInError(message: safeError.localizedDescription)
                }
            }
        }
    }

    internal func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: delegate!) { [weak self] result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { user, error in
                guard error == nil else {
                    (self?.delegate as? LoginViewDelagate)?.signInError(message: error!.localizedDescription)
                    return
                }

                if let strongUser = user {
                    let user = User(name: strongUser.user.uid, email: strongUser.user.email!)
                    (self?.delegate as? LoginViewDelagate)?.didSignInSuccessfully(user: user)
                }
            }
        }
    }
}
