//
//  Observable+KeyPath.swift
//  FNEasyBind
//
//  Created by Fabio Nisci on 27/03/2020.
//

import Foundation

/// Helper methods for binding an observable to a property using `KeyPath` feature.
public extension Observable {
    
    /// Automatically subscribe and update property of an object accroding the keypath
    /// - Parameters:
    ///   - object: usually uiview subclass or any object to update
    ///   - keyPath: keypath `\.property`
    /// - Returns: a disposable object
    func bind<Root: AnyObject>(on object: Root, to keyPath: ReferenceWritableKeyPath<Root, Value>) -> Disposable {
        subscribe { newValue, _ in
            object[keyPath: keyPath] = newValue
        }
    }

    /// Automatically subscribe and update property of an object accroding the keypath (for optionals)
    /// - Note: useful for `UILabel \.text` optional property
    /// - Parameters:
    ///   - object: usually uiview subclass or any object to update
    ///   - keyPath: keypath `\.property`
    /// - Returns: a disposable object
    func bind<Root>(on object: Root, to keyPath: ReferenceWritableKeyPath<Root, Value?>) -> Disposable {
        subscribe { newValue, _ in
            object[keyPath: keyPath] = newValue
        }
    }
}
