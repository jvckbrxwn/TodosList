//
//  RegistrationPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 05.04.2023.
//

import FirebaseAuth

protocol RegistrationPresenterDelegate: BasePresenterDelegate {
    func didRegisterSuccessfully(user: User)
    func didRegisterError(message: String)
}

class RegistrationPresenter: BasePresenter {
    func register(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                (self?.delegate as? RegistrationPresenterDelegate)?.didRegisterError(message: error!.localizedDescription)
                return
            }

            guard let safeUser = result?.user else { return }
            let user = User(name: safeUser.uid, email: safeUser.email!)
            (self?.delegate as? RegistrationPresenterDelegate)?.didRegisterSuccessfully(user: user)
        }
    }
}
