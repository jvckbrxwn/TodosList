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
}

class TodoItemPresenter: BasePresenter {
    private let db = Firestore.firestore()
    private var itemsListener: ListenerRegistration?

    internal var selectedCategory: String? {
        didSet{
            if oldValue == selectedCategory { return }
            
            (delegate as? TodoItemPresenterDelegate)?.didCategoryWasChanged()
            itemsListener?.remove()
            getItems()
            initListener()
        }
    }

    internal func addItem(_ item: TodoItem) {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        do {
            try db.collection(userInfo.email).document(selectedCategory!).collection("todos").addDocument(from: item)
        } catch {
            print(error)
        }
    }

    internal func updateItem(_ item: TodoItem) {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        do {
            if let docID = item.id {
                try db.collection(userInfo.email).document(selectedCategory!).collection("todos").document(docID).setData(from: item)
            }
        } catch {
            print(error)
        }
    }

    internal func deleteItem(_ item: TodoItem) { // , handler: @escaping () -> Void) {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }
        guard let docID = item.id else { return }
        print(docID)

        db.collection(userInfo.email).document(selectedCategory!).collection("todos").document(docID).delete()
    }

    private func getItems() {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        db.collection(userInfo.email).document(selectedCategory!).collection("todos").getDocuments { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { return }
            do {
                var items = [TodoItem]()
                try snapshot.documents.forEach { items.append(try $0.data(as: TodoItem.self)) }
                (self?.delegate as? TodoItemPresenterDelegate)?.didGetItems(items: items)
            } catch {
                print(error)
            }
        }
    }

    private func initListener() {
        guard let userInfo = UserManager.shared.getUserInfo() else { return }

        itemsListener = db.collection(userInfo.email).document(selectedCategory!)
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
                        print(error)
                    }
                })
            }
    }
}
