//
//  Container.swift
//  TinyDI
//
//  Created by Olaf Conijn on 07/04/2017.
//  Copyright © 2017 Olaf Conijn. All rights reserved.
//

import Foundation

///A simple container class that supports the following usecases
///
///creating a container:
///
///   let c = Container()
///
///registering/resolving simple types:
///
///   c.registerInstance(42)  //registers an Int
///   c.register({ 42 }) //registers an Int 'lazyly'
///   42 == c.resolve() //returns true
///
///registering/resolving a service using protocol:
///
///   c.register({ MyClass() as MyProtocol }) //registers concrete class as protocol
///   c.resolve()! as MyProtocol //resolves instance of MyClass
///   c.resolve()! is MyClass //evaluates to true
///
///dependency injection:
///
///   c.register({ MyClass(c.resolve(), arg2: c.resolve(), arg3: c.resolve()) }) //dependency injection
///   let cl = c.resolve()! as MyClass //resolves the whole dependency tree
///
///registering a non-singleton class:
///
///   c.register({ MyClass() }, singleton: false) //registers as transient class
///   let p = c.resolve()! as MyClass
///   let p2 = c.resolve()! as MyClass
///   p !== p2 //returns true
///
public class Container: CustomDebugStringConvertible {
    private var registrations = [ContainerType: ContainerValue]()

    public init () {}

    public func register<T>(_ fnInit: @escaping () -> T) {
        self.register(fnInit, singleton: true)
    }

    public func register<T>(_ fnInit: @escaping () -> T, singleton: Bool) {
        let type = ContainerType(T.self)
        registrations[type] = LazyContainerValue(fnInit, singleton: singleton)
    }

    public func registerInstance<T>(_ value: T) {
        let type = ContainerType(T.self)
        registrations[type] = FixedContainerValue(value)
    }

    public func resolve<T>() -> T? {
        let type = ContainerType(T.self)
        if let registration = registrations[type] {
            return registration.getInstance() as? T
        } else {
            return nil
        }
    }

    public var debugDescription: String {
        return registrations.keys.map({$0.debugDescription}).joined(separator: "\n")
    }

    private class ContainerType: CustomDebugStringConvertible, Hashable, Equatable {
        var type: String!

        init(_ type: Any.Type) {
            self.type = "\(type)"
        }

        public var hashValue: Int {
            return type.hashValue
        }

        public static func == (lhs: ContainerType, rhs: ContainerType) -> Bool {
            return rhs.type == lhs.type
        }

        public var debugDescription: String {
            return "registered type: \(type)"
        }
    }

    private class FixedContainerValue: ContainerValue {
        let val : Any

        init(_ val: Any) {
            self.val = val
        }

        override func getInstance() -> Any {
            return val
        }
    }

    private class LazyContainerValue: ContainerValue {
        let fnInit: () -> Any
        let singleton: Bool
        var cachedInstance : Any?

        init(_ fnInit: @escaping () -> Any, singleton: Bool) {
            self.fnInit = fnInit
            self.singleton = singleton
        }

        override func getInstance() -> Any {
            if let previouslyCached = cachedInstance {
                return previouslyCached
            }

            let instance = fnInit()

            if singleton {
                cachedInstance = instance
            }

            return instance
        }
    }

    private class ContainerValue {
        func getInstance() -> Any {
            return ""
        }
    }
}
