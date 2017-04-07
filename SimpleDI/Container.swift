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
/// registering values:
///   let c = Container()
///   c.registerValue(MyValue())
///   let value: MyValue = c.resolve()
///
/// registering functions:
///   let c = Container()
///   c.register({ MyValue() })
///   let value: MyValue = c.resolve()
///
/// registering services over protocol:
///   let c = Container()
///   c.register({ MyValue() as MyProtocol })
///   let value: MyProtocol = c.resolve()
///
/// dependency injection:
///   // assumes a class MyValue with init(_ arg: MyDependency1, other: MyDependency2))
///
///   let c = Container()
///   c.register({ MyValue(c.resolve(), other: c.resolve()) })
///   c.register({ MyDependency1() })
///   c.register({ MyDependency2() })
///   let value: MyValue = c.resolve()
class Container : CustomDebugStringConvertible {
    private var registrations = [ContainerType:ContainerValue]()
    
    func register<T>(_ fn: @escaping ()->T) {
        self.register(fn, singleton: true)
    }
    
    func register<T>(_ fn: @escaping ()->T, singleton: Bool) {
        let type = ContainerType(T.self)
        registrations[type] = LazyContainerValue(fn, singleton: singleton)
    }
    
    func registerInstance<T>(_ value: T) {
        let type = ContainerType(T.self)
        registrations[type] = FixedContainerValue(value)
    }
    
    func resolve<T>() -> T? {
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
        var type : String!
        
        init(_ type: Any.Type) {
            self.type = "\(type)"
        }
        
        public var hashValue: Int {
            return type.hashValue
        }
        
        public static func ==(lhs: ContainerType, rhs: ContainerType) -> Bool {
            return rhs.type == lhs.type
        }
        
        public var debugDescription: String {
            return "registered type: \(type)"
        }
    }
    
    private class FixedContainerValue : ContainerValue {
        let val : Any
        
        init(_ val: Any) {
            self.val = val
        }
        
        override func getInstance() -> Any {
            return val
        }
    }
    
    private class LazyContainerValue : ContainerValue {
        let fn: () -> Any
        let singleton: Bool
        var cachedInstance : Any?
        
        init(_ fn: @escaping () -> Any, singleton: Bool) {
            self.fn = fn
            self.singleton = singleton
        }
        
        override func getInstance() -> Any {
            if let previouslyCached = cachedInstance {
                return previouslyCached
            }
            
            let instance = fn()
            
            if (singleton) {
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
