//
//  Disposable.swift
//  FNEasyBind
//
//  Created by Fabio Nisci on 27/03/2020.
//

import Foundation

/// Helper matching name for RxSwift (a bag is an array of Disposable objects)
public typealias DisposeBag = [Disposable]

/// ** Disposable **
/// When an object subscribes to a sequence, it isn’t directly holding reference to it. Therefore, if you don’t manually terminate your subscriptions, you can risk leaking memory. It is possible to dispose of your subscriptions individually, but to make life simple it is most common to create an object of type DisposeBag. Essentially, the dispose bag holds any number of objects that conform to the Disposable protocol. In its deinit method, the dispose bag goes through each of the disposable objects and removes them from memory.
public final class Disposable {

    public typealias Dispose = () -> Void
    private let dispose: Dispose

    /// Creates a new instance.
    ///
    /// - Parameter dispose: The closure to call on deinit
    public init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

    /// Call the closure.
    deinit {
        dispose()
    }

    /// Adds to the bag
    public func disposed(by bag: inout DisposeBag) {
        bag.append(self)
    }
}
