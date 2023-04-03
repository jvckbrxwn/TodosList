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
    internal func checkIfUserLoggedIn(){
        if let currentUser = Auth.auth().currentUser {
            let user = User(name: currentUser.uid, email: currentUser.email!)
            (self.delegate as? LoginViewDelagate)?.didSignInSuccessfully(user: user)
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

            Auth.auth().signIn(with: credential) {_, error in
                guard error == nil else {
                    (self?.delegate as? LoginViewDelagate)?.signInError(message: error!.localizedDescription)
                    return
                }

                if let result = result {
                    let user = User(name: result.user.userID!, email: result.user.profile!.email)
                    (self?.delegate as? LoginViewDelagate)?.didSignInSuccessfully(user: user)
                }
            }
        }
    }
}
