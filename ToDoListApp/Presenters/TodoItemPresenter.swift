//
//  TodoItemPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 22.03.2023.
//

import FirebaseFirestore
import UIKit

protocol TodoItemPresenterDelegate: BasePresenterDelegate {
    func didItemsGet(todoItems: [TodoItem])
}

class TodoItemPresenter: BasePresenter {
    let db = Firestore.firestore()

    internal var selectedCategory: String? {
        didSet {
            getItems()
        }
    }

    internal func getItems() {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        var todoItems = [TodoItem]()
        db.collection(userInfo.email).document(selectedCategory!).collection("todos")
            .getDocuments { [weak self] snapshot, _ in
                if let safeSnap = snapshot {
                    for doc in safeSnap.documents {
                        todoItems.append(TodoItem(isDone: Bool(truncating: doc["isDone"] as! NSNumber), name: doc.documentID))
                    }
                }
                (self?.delegate as? TodoItemPresenterDelegate)?.didItemsGet(todoItems: todoItems)
            }
    }

    internal func addItem(name: String, _ isDone: Bool = false) {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        db.collection(userInfo.email).document(selectedCategory!).collection("todos").document(name).setData(["isDone": isDone]) { _ in
            self.getItems()
        }
    }

    internal func updateItem(name: String, value: Bool, handler: @escaping () -> Void) {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        db.collection(userInfo.email).document(selectedCategory!).collection("todos").document(name).updateData(["isDone": value]) { error in
            guard error == nil else { return }
            
            self.getItems()
            handler()
        }
    }
}
