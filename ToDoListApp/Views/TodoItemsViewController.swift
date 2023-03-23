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

    internal var selectedCategoryName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addItemClicked))
        presenter.setDelegate(delegate: self)
        presenter.selectedCategory = selectedCategoryName // get items after selected category was set
        title = "Todo items"
    }

    @objc private func addItemClicked() {
        var itemNameTextField = UITextField()
        let addItemAlert = UIAlertController(title: "Add item", message: "Enter the name to the new item", preferredStyle: .alert)
        addItemAlert.addTextField { textField in
            itemNameTextField = textField
        }
        addItemAlert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            if let name = itemNameTextField.text {
                self.presenter.addItem(name: name)
            }
        })
        present(addItemAlert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = todoItems[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.name
        cell.contentConfiguration = config
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems.count
    }
}

extension TodoItemsViewController: TodoItemPresenterDelegate {
    func didItemsGet(todoItems: [TodoItem]) {
        self.todoItems = todoItems
        tableView.reloadData()
    }

    func didItemAdded() {
        print("Item added")
    }
}
