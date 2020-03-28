//
//  Observable.swift
//  FNEasyBind
//
//  Created by Fabio Nisci on 27/03/2020.
//

import Foundation


/// **Observable - base**
/// Objects can subscribe to receive events from the sequence.
/// - Note: Abstract class
public class Observable<T> {
    
    public typealias Value = T
    public typealias OldValue = T?
    public typealias Observer = (_ value: Value, _ oldValue: OldValue) -> Void
    fileprivate typealias ObserverIndex = Int
    
    private var observers: [ObserverIndex: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    fileprivate let lock = NSRecursiveLock()
    
    fileprivate var _onDispose: () -> Void
    
    public init(_ value: T, onDispose: @escaping () -> Void = {}) {
        _value = value
        _onDispose = onDispose
    }
    
    public init(_ value: T) {
        _value = value
        _onDispose = {}
    }
    
    /// When you use the .subscribe method, you are subscribing an event handler to an observable sequence. In the closure, you specify how you want to handle the different events that are emitted by the sequence. In this case, regardless of the event type, we are printing the event to the console.
    /// - Important: Alway use [weak self] to avoid retain cycles
    /// - Note:
    /// You can see the output is:
    /// - next(One), next(Two), next(Three), next(Four), completed
    ///
    /// Under the hood, Event is simply an enum with cases. (TO BE IMPLEMENTED)
    /// - Parameters:
    ///   - queue: optionally dispatch on this queue
    ///   - observer: subscribed observer
    /// - Returns: A Disposable object that can be added to the (you guessed it) dispose bag. The .diposed(by: &disposeBag) operator, simply adds the subscription (of Disposable type) to the dispose bag
    public func subscribe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        notify(observer: observer, queue: queue, value: value)
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
            self?._onDispose()
        }
        
        return disposable
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    fileprivate func notify(observer: @escaping Observer, queue: DispatchQueue? = nil, value: T, oldValue: T? = nil) {
        if let queue = queue {
            queue.async {
                observer(value, oldValue)
            }
        } else {
            observer(value, oldValue)
        }
    }
    
    fileprivate func notifyObservers(value: T, oldValue: T? = nil) {
        observers.values.forEach { observer, dispatchQueue in
            notify(observer: observer, queue: dispatchQueue, value: value, oldValue: oldValue)
        }
    }
    
    
    fileprivate var _value: Value{
        didSet {
            let newValue = _value
            notifyObservers(value: newValue, oldValue: oldValue)
        }
    }
    
    /// Use this only for testing, you should get the right value using *-subscribe* method
    public var value: Value {
        get {
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
    
}


// MARK: PublishSubject
/// **PublishSubject - no-replay**
/// A PublishSubject is concerned only with emitting new events to its subscribers. It does not replay next() events, so any that existed before the subscription will not be received by that subscriber. It does re-emit stop events to new subscribers however. This means that if you subscribe to a sequence that has already been terminated, the subscriber will receive that information. It is worth noting that all subject types re-emit stop events.
/// A good use case for a PublishSubject is any sort of ticker. If you want a live feed of information, you likely don’t want to receive any historical events. This makes the PublishSubject ideal for your purpose.
public final class PublishSubject<T>: Observable<T>{
    
    /// Updates the publish subject using the given value.
    public func update(_ value: Value) {
        let oldValue = _value
        _value = value
        
        // We inform the observer here instead of using `didSet` on `_value` to prevent unwrapping an optional (`_value` is nullable, as we're starting empty).
        // Unwrapping lead to issues / crashes on having an underlying optional type, e.g. `PublishSubject<Int?>`.
        notifyObservers(value: value, oldValue: oldValue)
    }
    
}

// MARK: BehaviorSubject
/// **BehaviorSubject - replay a single next event (last)**
/// A BehaviorSubject stores the most recent next() event, which is able to be replayed to new subscribers. In other words, a new subscriber can receive the most recent next() event even if they subscribe after the event was emitted. A BehaviorSubject must not have an empty buffer, so it is initialized with a starting value which acts as the initial next() event. This value gets overwritten as soon as a new element is added to the sequence.
public final class BehaviorSubject<T>: Variable<T> {
    
}

// MARK: Variable
/// **Variable - replay a single next event (last)**
/// At it’s heart, Variable is a wrapper around BehaviorSubject that allows for simpler handling. Instead of the usual sending of next() events, Variable provides dot syntax for getting and setting a single value that is both emitted as a next() event and stored for replay. The exposed .value property gets and sets the value to a privately stored property _value. Additionally, it creates a new next() event for the privately held BehaviorSubject contained in the Variable in the setter method. Variable also has a method .asObservable()which returns the privately held BehaviorSubject in order to manage its subscribers.
public class Variable<T>: Observable<T> {

    public func asObservable() -> Variable<T> {
        return self
    }

    /// Initializes a new variable with the given value.
    ///
    /// - Note: We keep the initializer to the super class `Observable` fileprivate in order to verify always having a value.
    public override convenience init(_ value: Value) {
        self.init(value, onDispose: {})
    }
    
    public override init(_ value: T, onDispose: @escaping () -> Void = {}) {
        super.init(value, onDispose: onDispose)
        _value = value
    }

    public override func subscribe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observable<T>.Observer) -> Disposable {
        // A variable should inform the observer with the initial value.
        observer(_value, nil)

        return super.subscribe(queue, observer)
    }
}


// MARK ReplaySubject
/// ReplaySubject
/// So far we have seen a subject with no replay (PublishSubject) and two subjects that replay a single next event (BehaviorSubject and Variable). As its name suggests, the ReplaySubject provides you the ability to replay many next events. In order to do this, you specify your buffer size when you instantiate the ReplaySubject, and it maintains your latest next events up to the buffer limit. When a new subscriber is added, the events stored in the buffer are replayed one after the other as if they are occurring in rapid succession immediately after subscription. Once again, stop events are re-emitted to new subscribers.
/// Good use cases for a Replay subject are those recording historical information such as storing most recent search terms or operations that a user might want to undo.
@available(*, unavailable)
public final class ReplaySubject<T>: Observable<T>{
    override convenience init(_ value: T) {
        self.init(value, onDispose: {})
    }
    override init(_ value: T, onDispose: @escaping () -> Void = {}) {
        fatalError("ReplaySubject to be implemented")
    }
}
