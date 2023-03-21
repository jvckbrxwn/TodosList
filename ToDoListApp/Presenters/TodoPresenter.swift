//
//  TodoPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import FirebaseFirestore
import UIKit

protocol TodoPresenterDelegate: BasePresenterDelegate {
    func didGetTodosSuccessully(todos: [Todo])
}

class TodoPresenter: BasePresenter {
    let dataBase = Firestore.firestore()

    public func getTodos(from collectionName: String) {
        dataBase.collection("todos").document(collectionName).collection("items").getDocuments { [weak self] snapshot, error in
            guard let safeSnapshot = snapshot, error == nil else { return }
            var todos = [Todo]()
            DispatchQueue.main.async {
                var items = [TodoItem]()
                for doc in safeSnapshot.documents {
                    let isDone = Bool(truncating: doc["isDone"] as! NSNumber)
                    let name = doc["name"] as! String
                    let item = TodoItem(isDone: isDone, name: name)
                    items.append(item)
                }

                todos.append(Todo(name: "Home", items: items))
                (self?.delegate as? TodoPresenterDelegate)?.didGetTodosSuccessully(todos: todos)
                
            }
        }
    }
}
