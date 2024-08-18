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

struct Article {
    var funcA: ((Int) -> String)?
    var funcB: (() -> Void)?
    var name: String

    // this could be generated by a tool? Like Tuist.
    static var keyPathList: [AnyKeyPathWrapper<Article>] = [
        AnyKeyPathWrapper(\Article.funcA),
        AnyKeyPathWrapper(\Article.funcB),
        AnyKeyPathWrapper(\Article.name)
    ]
}

// Changes the closure on P at the keyPath, replacing it with F
// (and an escaping variant? etc)
func modifyClosure<P, F>(in object: inout P, closureKeyPath: WritableKeyPath<P, F>, newClosure: F) {
    object[keyPath: closureKeyPath] = newClosure
}

struct AnyKeyPathWrapper<T> {
    let setValue: (inout T, Any) -> Void
    let keyPath: PartialKeyPath<T>
    let propertyName: String

    // Initializes the wrapper with a specific WritableKeyPath
    init<U>(_ keyPath: WritableKeyPath<T, U>) {
        self.keyPath = keyPath
        self.propertyName = Self.getPropertyName(from: keyPath)
        print("For keyPath \(keyPath) I found prop name: \(self.propertyName)")
        self.setValue = { object, value in
            // Attempt to cast the value to the expected type (U) and assign it
            if let castValue = value as? U {
                object[keyPath: keyPath] = castValue
            } else {
                print("Type mismatch for property at key path: \(keyPath)")
            }
        }
    }

    // Extracts the property name by stripping the leading struct name from the key path
    private static func getPropertyName<U>(from keyPath: KeyPath<T, U>) -> String {
        let keyPathString = String(describing: keyPath)
        if let dotRange = keyPathString.firstIndex(of: ".") {
            // Extract everything after the first dot (removing the struct name)
            let propertyName = keyPathString[keyPathString.index(after: dotRange)...]
            return String(propertyName)
        }
        return keyPathString  // Fallback in case the format is unexpected
    }

}

public func do_it3() {
    var article = Article(funcA: { i in "1. Int is: \(i)" },
                          funcB: { print("1. Funcs B exec") },
                          name: "AlexH")

    // just a helper for new values, this can go later
    let newValues: [String: Any] = [
        "name": "AAxleeeeee"
    ]

    // Loop through the key paths and assign the corresponding new values
    for keyPathWrapper in Article.keyPathList {
        // Check if there is a corresponding value for the key path property
        if let newValue = newValues[keyPathWrapper.propertyName] {
            setDynamicValue(newValue, for: keyPathWrapper, on: &article)
        } else {
            print("No value provided for property: \(keyPathWrapper.propertyName)")
        }
    }
    print(article)
}

func setDynamicValue<T>(_ value: Any, for keyPathWrapper: AnyKeyPathWrapper<T>, on object: inout T) {
    keyPathWrapper.setValue(&object, value)
}

/// -------------------------------------------------------------------------------------
