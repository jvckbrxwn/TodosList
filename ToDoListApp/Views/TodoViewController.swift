//
//  TodoViewController.swift
//  ToDoListApp
//
//  Created by Mac on 20.03.2023.
//

import FirebaseFirestore
import UIKit

class TodoViewController: UITableViewController {
    let todoPresenter = TodoPresenter()

    var todos = [Todo]()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hello, \(user?.email ?? "NoName")"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        todoPresenter.setDelegate(delegate: self)
        todoPresenter.getTodos(from: "Home")
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
    }
}

extension TodoViewController: TodoPresenterDelegate {
    func didGetTodosSuccessully(todos: [Todo]) {
        self.todos = todos
        print(todos.count)
        tableView.reloadData()
    }
}
