//
//  Created by Olaf Conijn on 07/04/2017.
//  Copyright © 2017 Olaf Conijn. All rights reserved.
//
//swiftlint:disable force_cast
import XCTest
@testable import SimpleDI

class ContainerTests: XCTestCase {

    func testCanRegisterValue() {
        let c = Container()
        let s = SomeObject()

        c.registerInstance(42)
        c.registerInstance("hello")
        c.registerInstance(s)
        c.registerInstance([1, 2, 3])

        XCTAssertEqual("hello", c.resolve())
        XCTAssertEqual(42, c.resolve())
        XCTAssertEqual([1, 2, 3], c.resolve()!)

        let resolved: SomeObject = c.resolve()!
        XCTAssertTrue(s === resolved)
    }

    func testLastRegisterWins() {
        let c = Container()

        c.registerInstance(22)
        c.register({ return 32 })
        c.registerInstance(42)

        XCTAssertEqual(42, c.resolve())
    }

    func testCanRegisterFunction() {
        let c  = Container()
        let s = SomeObject()

        c.register({ 42 })
        c.register({ "hello" })
        c.register({ s })
        c.register({ [1, 2, 3] })

        XCTAssertEqual("hello", c.resolve()!)
        XCTAssertEqual(42, c.resolve()!)
        XCTAssertEqual([1, 2, 3], c.resolve()!)

        let resolved: SomeObject = c.resolve()!
        XCTAssertTrue(s === resolved)
    }

    func testCanRegisterProtocol() {
        let c  = Container()

        c.register({ ImplementsProtocol() as MyProtocol })

        let protocol_ = c.resolve()! as MyProtocol
        let concreteType = c.resolve() as ImplementsProtocol?

        XCTAssertNotNil(protocol_)
        XCTAssertNil(concreteType)
    }

    func testCanRegisterSameInstanceTwice() {
        let container  = Container()

        container.register({ ImplementsProtocol() as MyProtocol })
        container.register({ c in (c.resolve()! as MyProtocol) as! ImplementsProtocol })

        let protocol_ = container.resolve()! as MyProtocol
        let concreteType: ImplementsProtocol? = container.resolve()

        XCTAssertNotNil(protocol_)
        XCTAssertNotNil(concreteType)
        XCTAssertTrue(protocol_ as? ImplementsProtocol === concreteType)
    }

    func testRegisterIsLazilyInvoked() {
        let c  = Container()
        var callcount = 0

        c.register({ () -> String in
            callcount += 1
            return "hello"
        })

        XCTAssertEqual(0, callcount)
        XCTAssertEqual("hello", c.resolve())
        XCTAssertEqual(1, callcount)
    }

    func testRegisterDefaultsToSingleton() {
        let c  = Container()
        var callcount = 0

        c.register({ () -> SomeObject in
            callcount += 1
            return SomeObject()
        })

        let object1: SomeObject = c.resolve()!
        let object2: SomeObject = c.resolve()!

        XCTAssertEqual(1, callcount)
        XCTAssertTrue(object1 === object2)
    }

    func testRegisterCanRegisterTransientObjects() {
        let c  = Container()

        c.register({ return SomeObject()}, singleton: false)

        let object1: SomeObject = c.resolve()!
        let object2: SomeObject = c.resolve()!

        XCTAssertTrue(object1 !== object2)
    }

    func testResolveReturnsNilForUnregisteredTypes() {
        let c  = Container()

        let obj: SomeObject? = c.resolve()

        XCTAssertNil(obj)
    }

    func testCanResolveComplexGraph () {
        let container = Container()
        container.register({ c in Fruit(c.resolve()!)})
        container.register({ c in StringContainer(c.resolve()!)})
        container.register({ c in Basket(fruit: c.resolve()!, number: c.resolve()!)})
        container.register({ "Banana"})
        container.register({ 12})

        let bananaBasket: Basket = container.resolve()!
        XCTAssertNotNil(bananaBasket)
        XCTAssertEqual(12, bananaBasket.number)
        XCTAssertNotNil(bananaBasket.fruit)
        XCTAssertNotNil(bananaBasket.fruit.name)
        XCTAssertEqual("Banana", bananaBasket.fruit.name.value)
    }

    func testHasDebugDescription() {
        let c = Container()
        c.register({ "Banana"})
        c.registerInstance(42)

        let s = String(reflecting: c)
        XCTAssertTrue(s.contains("Int"))
        XCTAssertTrue(s.contains("String"))
    }

    private struct Basket {
        let fruit: Fruit
        let number: Int
    }

    private class Fruit {
        let name: StringContainer

        init(_ name: StringContainer) {
            self.name = name
        }
    }

    private class StringContainer {
        let value: String

        init(_ value: String) {
            self.value = value
        }
    }

    class SomeObject {

    }

    class ImplementsProtocol: MyProtocol {

    }

}

protocol MyProtocol {

}
