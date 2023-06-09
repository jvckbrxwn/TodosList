//
//  TodoItemsViewController.swift
//  ToDoListApp
//
//  Created by Mac on 21.03.2023.
//

import UIKit

class TodoItemsViewController: UITableViewController {
    private var presenter = TodoItemPresenter()
    private var todoItems = [TodoItem]()
    private var addButton, editButton, endEditingButton: UIBarButtonItem?

    internal var selectedCategoryName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        navBarInitButtons()
        navBarSetButtons([addButton!, editButton!])
        presenter.setDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        presenter.selectedCategory = selectedCategoryName // get items after selected category was set
        title = selectedCategoryName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //TODO: change to another view without alert with textField
    @objc private func addItemClicked() {
        var itemNameTextField = UITextField()
        let addItemAlert = UIAlertController(title: "Add item", message: "Enter the name to the new item", preferredStyle: .alert)
        addItemAlert.addTextField { textField in
            itemNameTextField = textField
        }
        addItemAlert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            if let name = itemNameTextField.text {
                self.presenter.addItem(TodoItem(isDone: false, name: name, creationDate: Date()))
            }
        })
        addItemAlert.addAction(UIAlertAction(title: "Close", style: .cancel){ _ in
            addItemAlert.dismiss(animated: true)
        })
        present(addItemAlert, animated: true)
    }

    @objc private func editTableItems() {
        tableView.setEditing(true, animated: true)
        navBarSetButtons([endEditingButton!])
    }

    @objc private func endEditingItems() {
        tableView.setEditing(false, animated: true)
        navBarSetButtons([addButton!, editButton!])
    }

    private func navBarSetButtons(_ buttons: [UIBarButtonItem]) {
        navigationItem.rightBarButtonItems = buttons
    }

    private func navBarInitButtons() {
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addItemClicked))
        editButton = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: #selector(editTableItems))
        endEditingButton = UIBarButtonItem(image: UIImage(systemName: "pencil.slash"), style: .plain, target: self, action: #selector(endEditingItems))
    }
}

extension TodoItemsViewController: TodoItemPresenterDelegate {
    func didGetError(message: String) {
        let alert = ErrorAlert.shared.show(title: "Internal error", errorMessage: message)
        present(alert, animated: true)
    }
    
    func didCategoryWasChanged() {
        todoItems = []
        tableView.reloadData()
    }
    
    func didGetItems(items: [TodoItem]) {
        todoItems = items
        tableView.reloadData()
    }
    
    func didItemUpdated(item: TodoItem) {
        let index = todoItems.firstIndex(where: { $0.name == item.name })
        if let i = index {
            todoItems[i] = item
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
    }

    func didItemRemoved(item: TodoItem) {
        let index = todoItems.firstIndex(where: { $0.name == item.name })
        if let i = index {
            todoItems.remove(at: i)
            tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
    }

    func didItemAdded(item: TodoItem) {
        todoItems.append(item)
        tableView.insertRows(at: [IndexPath(row: todoItems.count - 1, section: 0)], with: .automatic)
    }
}

// MARK: - Table view data source

extension TodoItemsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = todoItems[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.name
        cell.contentConfiguration = config
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
        presenter.updateItem(todoItems[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteItem(todoItems[indexPath.row])
        }
    }
}
