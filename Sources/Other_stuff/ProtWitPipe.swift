//
//  ProtWitPipe.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 08/07/2024.
//

import Foundation
import OSLog

//@main
//struct Main {
//    static func main() throws {
//    }
//}

public protocol WitnessPiping { }

// piping implementation
extension WitnessPiping {

    public func callAsFunction<T, R>(_ keyPath: KeyPath<Self, ((T) -> R)>, args: T) -> R {
        self[keyPath: keyPath](args)
    }
}

// notocol with pipe
public struct ExampleDemonstrating: WitnessPiping {
    //var action: ((message: String) -> Void)?
    public var add: ((a: Int, b: Int)) -> Int
    // note we can't use labels in below form!
    public var addB: (Int, Int) -> Int
}


// httpxs://steipete.com/posts/interposekit/

class Spy<A: Hashable, B, C> {
    var invocations: [A: B] = .init()

    public func __interpose(f: @escaping (A, B) -> C) -> (A, B) -> C {
      { (a, b) -> C in
        //(f:  A, args: B) in
        self.invocations[a] = b
        return f(a, b)
        //Interpose.log(["\(tag ?? "")", "P1 = \(p1)"])
      }
    }
}

//public func do_it() {
//    // make a PW
//    //    let example = ExampleDemonstrating(add: { (a: Int, b: Int) in  a+b },
//    //    let example = ExampleDemonstrating(add: { ((a: Int, b: Int)) in  a+b },
//    let example = ExampleDemonstrating(add: { (_ pp: (a: Int, b: Int)) -> Int in
//        return pp.a + pp.b
//    },
//                                       addB: { a, b in  return a+b })
//
//    // this ok. even with the labels
//    let x: Any = (a: 1, b: 1)
//
//    let y: Any = testo // ((Int, String) -> String)
//
//    print("SJSJ Example: \(example)")
//    //    let spy = Spy<KeyPath<ExampleDemonstrating, (Any) -> Any>, Any, Any>()
//    let spy = Spy<KeyPath<ExampleDemonstrating, Any>, Any, Any>()
//
//    let tryThis: (KeyPath<ExampleDemonstrating, Any>, Any) -> Any = example.callAsFunction as! (KeyPath<ExampleDemonstrating, Any>, Any) -> Any
//
////    let ff = spy.__interpose(f: example.callAsFunction) //(\.add, args: (a: 3, b: 5))
//
//    //
//    //    ff(\.add, args: (a: 3, b: 5))
//
//
//    //    let ff = spy.__interpose() example.callAsFunction //(\.add, args: (a: 3, b: 5))
//    //    print("SJSJ ff = \(ff)")
//
//    print("SJSJ run exmaple simple way: ", example(\.add, args: (a: 3, b: 5)))
//}

func testo(_: (a: Int, b: String)) -> String {
    return "hey"
}

/// -------------------------------------------------------------------------------------
