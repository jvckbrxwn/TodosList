//
//  Todo.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import Foundation

struct TodoItem: Codable {
    let isDone: Bool
    let name: String
}

struct Todo: Codable {
    let name: String
}
