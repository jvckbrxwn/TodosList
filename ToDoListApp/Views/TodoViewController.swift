//
//  TodoViewController.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class TodoViewController: UITableViewController {
    private let todoPresenter = TodoPresenter()
    private var firstTimeLogin = false
    private var todos = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello, \(UserManager.shared.getUserInfo()?.email ?? "NoName")"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        todoPresenter.setDelegate(delegate: self)
        todoPresenter.getTodos()
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addCategoryClicked))
    }

    override func viewWillAppear(_ animated: Bool) {
        if firstTimeLogin {
            title = "Todo"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        firstTimeLogin = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = todos[indexPath.row].name
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todoItemsVC = TodoItemsViewController()
        todoItemsVC.selectedCategoryName = todos[indexPath.row].name
        navigationController?.pushViewController(todoItemsVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completeHandler in
            self.todoPresenter.deleteTodo(name: self.todos[indexPath.row].name) {
                self.todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            completeHandler(true)
        }

        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Todo Presenter Delegate functions

extension TodoViewController: TodoPresenterDelegate {
    func didGetTodosSuccessully(todos: [Todo]) {
        self.todos = todos
        print(todos.count)
        tableView.reloadData()
    }
}

// MARK: - Main functionality

extension TodoViewController {
    @objc private func logOutClicked() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            firstTimeLogin = false
        } catch {
            let alert = UIAlertController(title: "Log out error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }

    @objc private func addCategoryClicked() {
        var categoryNameTextField = UITextField()
        let addCategoryAlert = UIAlertController(title: "Add category", message: "Enter the name to the new category", preferredStyle: .alert)
        addCategoryAlert.addTextField { textField in
            categoryNameTextField = textField
        }
        addCategoryAlert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            if let name = categoryNameTextField.text {
                self.todoPresenter.addTodo(name: name)
            }
        })
        present(addCategoryAlert, animated: true)
    }
}
