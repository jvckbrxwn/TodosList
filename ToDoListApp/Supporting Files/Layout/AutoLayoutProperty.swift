//
//  AutoLayoutProperty.swift
//  ToDoListApp
//
//  Created by Mac on 19.03.2023.
//

import UIKit

@propertyWrapper
public struct AutoLayoutProperty<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}
