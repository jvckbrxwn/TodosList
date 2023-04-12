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
    private lazy var todoPresenter = TodoPresenter()
    private lazy var todoItemsVC = TodoItemsViewController()
    private lazy var searchController = UISearchController()
    private var todos = [Todo]()
    private var filteredTodos = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        todoPresenter.setDelegate(delegate: self)
        todoPresenter.getTodos()
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addCategoryClicked))

        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !searchController.isActive ? todos.count : filteredTodos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = !searchController.isActive ? todos[indexPath.row].name : filteredTodos[indexPath.row].name
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todoItemsVC.selectedCategoryName = !searchController.isActive ? todos[indexPath.row].name : filteredTodos[indexPath.row].name
        searchController.isActive = false
        navigationController?.pushViewController(todoItemsVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completeHandler in
            self.todoPresenter.deleteTodo(name: self.todos[indexPath.row].name) {
                self.todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            completeHandler(true)
        }

        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Todo Presenter Delegate functions

extension TodoViewController: TodoPresenterDelegate {
    func didGetError(message: String) {
        let alert = ErrorAlert.shared.show(title: "Internal error", errorMessage: message)
        present(alert, animated: true)
    }

    func didGetTodosSuccessully(todos: [Todo]) {
        self.todos = todos
        tableView.reloadData()
    }
}

// MARK: - Main functionality

extension TodoViewController {
    @objc private func logOutClicked() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            let alert = ErrorAlert.shared.show(title: "Log out error", errorMessage: error.localizedDescription)
            present(alert, animated: true)
        }
    }

    // TODO: change to another view without alert with textFields
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

extension TodoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredTodos = todos.filter({ $0.name.lowercased().contains(text.lowercased()) })
        tableView.reloadData()
    }
}
