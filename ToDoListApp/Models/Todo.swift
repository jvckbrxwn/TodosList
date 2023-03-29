//
//  Todo.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import FirebaseFirestoreSwift

struct TodoItem: Codable {
    @DocumentID var id: String?
    var isDone: Bool
    let name: String
    let creationDate: Date
}

struct Todo: Codable {
    let name: String
    let creationDate: Date
}
