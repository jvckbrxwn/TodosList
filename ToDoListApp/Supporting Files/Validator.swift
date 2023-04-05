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

internal struct ValidationResult {
    let state: Bool
    let message: String?
}

internal struct Validator {
    static let shared = Validator()

    private let passwordMinLength = 6

    private init() { }

    func validate(email: String) -> ValidationResult {
        let state = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
        print("\(#function) tells \(email) validation is \(state)")
        return ValidationResult(state: state, message: state ? "" : "Email is not valid")
    }

    func validate(password: String) -> ValidationResult {
        let state = password != "" && password.count >= passwordMinLength
        print("\(#function) tells password validation is \(state)")
        return ValidationResult(state: state, message: state ? "" : "Password can't be empty or must contains more that 8 symbols")
    }

    func validate(password: String, confirmPassword: String) -> ValidationResult {
        let state = password.compare(confirmPassword, options: .caseInsensitive) == .orderedSame
        print("\(#function) tells passwords compare state is \(state)")
        return ValidationResult(state: state, message: state ? "" : "Passwords are not matching")
    }
}
