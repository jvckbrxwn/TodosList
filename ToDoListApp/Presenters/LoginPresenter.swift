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

protocol GoogleLoginDelegate: BasePresenterDelegate {
    func didSignInSuccessfully(user: User)
    func signInError(message: String)
}

class LoginPresenter: BasePresenter {
    internal func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let delegate = delegate else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: delegate) { result, error in
            guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self] _, error in
                guard error == nil else {
                    (self?.delegate as? GoogleLoginDelegate)?.signInError(message: error!.localizedDescription)
                    return
                }

                if let result = result {
                    print(result.user.userID!)
                    let user = User(name: result.user.userID!, email: result.user.profile!.email)
                    (self?.delegate as? GoogleLoginDelegate)?.didSignInSuccessfully(user: user)
                }
            }
        }
    }
}
