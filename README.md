# SimpleDi easy to understand DI and IoC for swift
SimpleDI : an easy to understand dependency injection (di) and inversion of control (ioc) container for swift.
* [implemented in 1 class](https://github.com/OlafConijn/SimpleDI/blob/master/SimpleDI/Container.swift)
* less than 100 lines of code
* readable syntax because of type inference
* [contains all commonly used di/ioc features](https://github.com/OlafConijn/SimpleDI/blob/master/SimpleDITests/ContainerTests.swift)
  * register/resolve services using an interface
  * configure lifetime (singleton/transient)
  * register/resolve fixed values
  * dependency injection

creating a container:

```swift
    let c = Container()
```

registering/resolving simple types:

```swift
    c.registerInstance(42)  //registers an Int
    c.register({ 42 }) //registers an Int 'lazyly'
    42 == c.resolve() //returns true
```

registering/resolving a service using protocol:

```swift
    c.register({ MyClass() as MyProtocol }) //registers concrete class as protocol
    c.resolve()! as MyProtocol //resolves instance of MyClass
    c.resolve()! is MyClass //evaluates to true
```

dependency injection:

```swift
    c.register({ MyClass(c.resolve(), arg2: c.resolve(), arg3: c.resolve()) }) //dependency injection
    let cl = c.resolve()! as MyClass //resolves the whole dependency tree
```

registering a non-singleton class:

```swift
    c.register({ MyClass() }, singleton: false) //registers as transient class
    let p = c.resolve()! as MyClass
    let p2 = c.resolve()! as MyClass
    p !== p2 //returns true
```

    
    


