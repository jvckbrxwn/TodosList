//
//  UserManager.swift
//  ToDoListApp
//
//  Created by Mac on 23.03.2023.
//

struct UserManager {
    static var shared: UserManager = UserManager()

    private var user: User?
    internal var currentUser: User? {
        get {
            user
        }
        set {
            user = newValue
        }
    }
}
