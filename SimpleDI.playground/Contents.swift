//: Playground - noun: a place where people can play

import SimpleDI


class MyClass : MyProtocol { }
protocol MyProtocol { }

var str = "Hello, playground"

let c = Container()

c.registerInstance(42)  //registers an Int
c.register({ 42 }) //registers an Int 'lazyly', overwrites previous
42 == c.resolve()


c.register({ MyClass() as MyProtocol }) //registers concrete class as protocol
c.resolve()! as MyProtocol //resolves instance of MyClass
(c.resolve()! as MyProtocol) is MyClass //evaluates to true


c.register({ MyClass() }, singleton: false) //registers as transient class
let p = c.resolve()! as MyClass
let p2 = c.resolve()! as MyClass
p !== p2 //returns true


