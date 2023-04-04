//
//  Validator.swift
//  ToDoListApp
//
//  Created by Mac on 30.03.2023.
//

import Foundation

public enum ValidationType {
    case email, password
}

internal struct Validator {
    static let shared = Validator()

    private init() { }

    func validate(email: String) -> Bool {
        let state = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
        print("\(#function) tells \(email) validation is \(state)")
        return state
    }

    func validate(password: String) -> Bool {
        let state = password != ""
        print("\(#function) tells \(password) validation is \(state)")
        return state
    }
}
