//: Playground - noun: a place where people can play

import SimpleDI

class MyClass: MyProtocol { }
protocol MyProtocol { }

var str = "Hello, playground"

let container = Container()

container.registerInstance(42)  //registers an Int
container.register({ 42 }) //registers an Int 'lazyly', overwrites previous
42 == c.resolve()

container.register({ MyClass() as MyProtocol }) //registers concrete class as protocol
container.resolve()! as MyProtocol //resolves instance of MyClass

container.register({ MyClass() }, singleton: false) //registers as transient class
let val1 = container.resolve()! as MyClass
let val2 = container.resolve()! as MyClass
val1 !== val2 //returns true
