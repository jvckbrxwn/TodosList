//
//  TodoPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import UIKit
import FirebaseFirestore

protocol TodoPresenterDelegate: AnyObject {
    func didGetTodosSuccessully(todos: [Todo])
}

typealias Presenter = TodoPresenterDelegate & UIViewController

class TodoPresenter {
    
    private weak var delegate: Presenter?
    
    let dataBase = Firestore.firestore()
    
    public func setDelegate(delegate: Presenter) {
        self.delegate = delegate
    }

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
                self?.delegate?.didGetTodosSuccessully(todos: todos)
            }
        }
    }
}
