//
//  TodoItemPresenter.swift
//  ToDoListApp
//
//  Created by Mac on 22.03.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

protocol TodoItemPresenterDelegate: BasePresenterDelegate {
    func didGetItems(items: [TodoItem])
    func didItemUpdated(item: TodoItem)
    func didItemRemoved(item: TodoItem)
    func didItemAdded(item: TodoItem)
    func didCategoryWasChanged()
    func didGetError(message: String)
}

class TodoItemPresenter: BasePresenter {
    private let db = Firestore.firestore()
    private var itemsListener: ListenerRegistration?
    private var userInfo: User?

    internal var selectedCategory: String? {
        didSet {
            if oldValue == selectedCategory { return }

            (delegate as? TodoItemPresenterDelegate)?.didCategoryWasChanged()
            itemsListener?.remove()
            getItems()
            initListener()
        }
    }

    internal func addItem(_ item: TodoItem) {
        isUserAvailable {
            do {
                try db.collection(userInfo!.email).document(selectedCategory!).collection("todos").addDocument(from: item)
            } catch {
                (delegate as? TodoItemPresenterDelegate)?.didGetError(message: error.localizedDescription)
            }
        }
    }

    internal func updateItem(_ item: TodoItem) {
        isUserAvailable {
            do {
                if let docID = item.id {
                    try db.collection(userInfo!.email).document(selectedCategory!).collection("todos").document(docID).setData(from: item)
                }
            } catch {
                (delegate as? TodoItemPresenterDelegate)?.didGetError(message: error.localizedDescription)
            }
        }
    }

    internal func deleteItem(_ item: TodoItem) {
        isUserAvailable {
            guard let docID = item.id else { return } // I think there is no reason to inform user about id's stuff, imho
            db.collection(userInfo!.email).document(selectedCategory!).collection("todos").document(docID).delete {
                error in
                guard let error = error else { return }
                (self.delegate as? TodoItemPresenterDelegate)?.didGetError(message: error.localizedDescription)
            }
        }
    }

    private func getItems() {
        isUserAvailable {
            db.collection(userInfo!.email).document(selectedCategory!).collection("todos").getDocuments { [weak self] snapshot, _ in
                guard let snapshot = snapshot else { return }
                do {
                    var items = [TodoItem]()
                    try snapshot.documents.forEach { items.append(try $0.data(as: TodoItem.self)) }
                    (self?.delegate as? TodoItemPresenterDelegate)?.didGetItems(items: items)
                } catch {
                    (self?.delegate as? TodoItemPresenterDelegate)?.didGetError(message: error.localizedDescription)
                }
            }
        }
    }

    private func initListener() {
        isUserAvailable {
            itemsListener = db.collection(userInfo!.email).document(selectedCategory!)
                .collection("todos").addSnapshotListener { [weak self] snapshot, _ in
                    guard let snapshot = snapshot else { return }
                    snapshot.documentChanges.forEach({ diff in
                        do {
                            switch diff.type {
                            case .added:
                                let item = try diff.document.data(as: TodoItem.self)
                                (self?.delegate as? TodoItemPresenterDelegate)?.didItemAdded(item: item)
                            case .modified:
                                let item = try diff.document.data(as: TodoItem.self)
                                (self?.delegate as? TodoItemPresenterDelegate)?.didItemUpdated(item: item)
                            case .removed:
                                let item = try diff.document.data(as: TodoItem.self)
                                (self?.delegate as? TodoItemPresenterDelegate)?.didItemRemoved(item: item)
                            }
                        } catch {
                            (self?.delegate as? TodoItemPresenterDelegate)?.didGetError(message: error.localizedDescription)
                        }
                    })
                }
        }
    }

    private func isUserAvailable(_ completition: () -> Void) {
        guard let userInfo = UserManager.shared.getUserInfo() else {
            (delegate as? TodoItemPresenterDelegate)?.didGetError(message: "User is not logged in")
            return
        }

        self.userInfo = userInfo
        completition()
    }
}
