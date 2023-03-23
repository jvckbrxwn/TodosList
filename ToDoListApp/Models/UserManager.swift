//
//  UserManager.swift
//  ToDoListApp
//
//  Created by Mac on 23.03.2023.
//

struct UserManager {
    static var shared: UserManager = UserManager()
    
    private var user: User?
    
    mutating func setUser(user: User){
        self.user = user
    }
    
    func getUserInfo() -> User? {
        return user
    }
}
