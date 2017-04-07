# SimpleDi easy to understand DI and IoC for swift
SimpleDI : an easy to understand dependency injection (di) and inversion of control (ioc) container for swift.
* [implemented in 1 class](https://raw.githubusercontent.com/OlafConijn/SimpleDI/master/SimpleDI/Container.swift)
* less than 100 lines of code
* readable syntax because of type inference
* [contains all commonly used di/ioc features](https://raw.githubusercontent.com/OlafConijn/SimpleDI/master/SimpleDITests/ContainerTests.swift)
  * register/resolve services using an interface
  * configure lifetime (singleton/transient)
  * register/resolve fixed values
  * dependency injection

creating a container:
    let c = Container()

registering/resolving simple types:
    c.registerInstance(42)  //registers an Int
    c.register({ return 42 }) //registers an Int 'lazyly'
    XCTAssertEqual(42, c.resolve()) //resolves an Int
    
registering/resolving a service using protocol:
    c.register({ return MyClass() as MyProtocol }) //registers concrete class as protocol
    let p = c.resolve() as MyProtocol //resolves instance of MyClass

dependency injection:
    c.register({ return MyClass(c.resolve(), arg2: c.resolve(), arg3: c.resolve()) }) //dependency injection
    let cl = c.resolve() as MyClass? //resolves the whole dependency tree
    
registering a non-singleton class:
    c.register({ return MyClass() }, singleton: false) //registers as transient class
    let p = c.resolve() as MyClass
    let p2 = c.resolve() as MyClass
    XCTAssertTrue(p !== p2)


    
    


