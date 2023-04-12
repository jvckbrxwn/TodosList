//
//  BasePresenter.swift
//  ToDoListApp
//
//  Created by Mac on 21.03.2023.
//

import UIKit

protocol BasePresenterDelegate: AnyObject {
}

class BasePresenter {
    internal weak var delegate: (BasePresenterDelegate & UIViewController)?

    internal func setDelegate(delegate: BasePresenterDelegate & UIViewController) {
        self.delegate = delegate
    }
}
