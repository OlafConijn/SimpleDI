# SimpleDi easy to understand DI and IoC for swift
SimpleDI : an easy to understand dependency injection (di) and inversion of control (ioc) container for swift.
* implemented in 1 class
* less than 100 lines of code
* readable syntax because of type inference
* contains all commonly used di/ioc features
  * register/resolve services using an interface
  * configure lifetime (singleton/transient)
  * register/resolve fixed values
  * dependency injection

examples:

    let c = Container()

    c.registerInstance(42)  //registers an Int
    c.register({ return 42 }) //registers an Int 'lazyly'
    XCTAssertEqual(42, c.resolve()) //resolves an Int
    
    c.register({ return MyClass() as MyProtocol }) //registers concrete class as protocol
    let p = c.resolve() as MyProtocol //resolves instance of MyClass
    let cl = c.resolve() as MyClass? //resolves nil

    c.register({ return MyClass(c.resolve(), arg2: c.resolve(), arg3: c.resolve()) }) //dependency injection
    let cl = c.resolve() as MyClass? //resolves the whole dependency tree



    
    


