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
    private let dataBase = Firestore.firestore()

    internal func getTodos() {
        guard let user = UserManager.shared.getUserInfo() else { return }

        var todoNames = [Todo]()
        dataBase.collection(user.email).getDocuments { [weak self] snapshot, _ in
            guard let snapshot = snapshot else {
                print("Can't get documents in \(String(describing: self)) in function \(#function)")
                return
            }

            for doc in snapshot.documents {
                todoNames.append(Todo(name: doc.documentID, creationDate: Date()))
            }

            (self?.delegate as? TodoPresenterDelegate)?.didGetTodosSuccessully(todos: todoNames)
        }
    }

    internal func addTodo(name: String) {
        guard let user = UserManager.shared.getUserInfo() else { return }

        dataBase.collection(user.email).document(name).setData([:]) { [weak self] error in
            guard error == nil else { return }
            self?.getTodos()
        }
    }

    internal func deleteTodo(name: String, handler: @escaping () -> Void) {
        guard let user = UserManager.shared.getUserInfo() else { return }

        let docRef = dataBase.collection(user.email).document(name)

        // TODO: docRef.collection("todos") cannot be deleted, to think about new methods to save and delete data
        docRef.collection("todos").getDocuments { snapshot, error in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let snapshot = snapshot else { return }

            snapshot.documents.forEach { doc in
                doc.reference.delete()
            }
            docRef.delete { _ in
                handler()
            }
        }
    }
}
