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
    func didGetError(message: String)
}

class TodoPresenter: BasePresenter {
    private let dataBase = Firestore.firestore()

    internal func getTodos() {
        guard let user = UserManager.shared.currentUser else { return }

        var todoNames = [Todo]()
        dataBase.collection(user.email).getDocuments { [weak self] snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                (self?.delegate as? TodoPresenterDelegate)?.didGetError(message: error!.localizedDescription)
                return
            }

            for doc in snapshot.documents {
                todoNames.append(Todo(name: doc.documentID, creationDate: Date()))
            }

            (self?.delegate as? TodoPresenterDelegate)?.didGetTodosSuccessully(todos: todoNames)
        }
    }

    internal func addTodo(name: String) {
        guard let user = UserManager.shared.currentUser else { return }

        dataBase.collection(user.email).document(name).setData([:]) { [weak self] error in
            guard error == nil else {
                (self?.delegate as? TodoPresenterDelegate)?.didGetError(message: error!.localizedDescription)
                return
            }
            self?.getTodos()
        }
    }

    internal func deleteTodo(name: String, handler: @escaping () -> Void) {
        guard let user = UserManager.shared.currentUser else { return }

        let docRef = dataBase.collection(user.email).document(name)

        // TODO: docRef.collection("todos") cannot be deleted, to think about new methods to save and delete data
        docRef.collection("todos").getDocuments { [weak self] snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                (self?.delegate as? TodoPresenterDelegate)?.didGetError(message: error!.localizedDescription)
                return
            }

            snapshot.documents.forEach { doc in
                doc.reference.delete()
            }
            docRef.delete { error in
                guard error == nil else {
                    (self?.delegate as? TodoPresenterDelegate)?.didGetError(message: error!.localizedDescription)
                    return
                }
                handler()
            }
        }
    }
}
