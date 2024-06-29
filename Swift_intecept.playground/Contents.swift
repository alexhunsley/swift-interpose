import UIKit
import PlaygroundSupport

/// Easy logging of closure calling with params.
/// Particularly useful for SwiftU previews.
///
/// Example:
///
///     // simplest use
///     actionHandler: ClosureDebug ()()
///
///  Example:
///
///     // the tag is also output
///     actionHandler: ClosureDebug(tag: "hey")())
///
///  Example:
///
///     // make just one for multiple uses
///     // (works even if the actions pass different amounts of params)
///     let closureDebug = ClosureDebug ()()
///       ...
///     actionHandler: closureDebug,
///     actionHandler2: closureDebug
///
/// Example output: (chec and redo these, prolly wrong!)
///     Closure debug: a = getStartedSelected [2024-06-28 12:29:33 +0000 Plan View.swift preview previews]
///     Closure debug: a = future YouAreOnTrackForSelected [2024-06-28 12:29:38 +0000 PlanView.swift preview previews!

// no possible! Would have to list the P1s on LHS so pointless!
//typealias P2R1 = (P1, P2) -> R1

// idea: intercept for making sure return value from a func never changes.
// Like memoize, but doing slightly less.
PlaygroundPage.current.needsIndefiniteExecution = true

public struct ClosureDebug {
    private let prefixString: String
    private let callSiteFunc: String
    private let callSiteFile: String

    public init(tag: String? = nil, _ callSiteFunc: String = #function, _ callSiteFile: String = #file) {
        self.prefixString = "Closure debug" + (tag == nil ? ":" : " [\(tag!)]:")
        self.callSiteFunc = callSiteFunc
        self.callSiteFile = callSiteFile
    }

    func output(_ str: String) {
        print("\(prefixString) \(str) [\(Date()) \(callSiteFile) \(callSiteFunc)]")
    }

    public func callAsFunction(tag: String? = nil) -> () -> Void {
        {
            // make this output special somehow? to indicate no param.
            output("<is a zero param func>")
        }
    }

    public func callAsFunction<P1>(tag: String? = nil) -> (P1) -> Void {
        { (p1: P1) in
            output("a = \(p1)")
        }
    }

    public func callAsFunction<P1, P2>(tag: String? = nil) -> (P1, P2) -> Void {
        { (p1: P1, p2: P2) in
            output("P1 = \(p1), P2 = \(p2)")
        }
    }

//    public func callAsFunction<A, B, C>(tag: String? = nil) -> (A, B, C) -> Void {
//        { (a: A, b: B, c: C) in
//            output("a = \(a), b = \(b), c = \(c)")
//        }
//    }
//
//    public func callAsFunction<A, B, C, D>(tag: String? = nil) -> (A, B, C, D) -> Void {
//        { (a: A, b: B, c: C, d: D) in
//            output("a = \(a), b = \(b), c = \(c), d = \(d)")
//        }
//    }
//
//    public func callAsFunction<A, B, C, D, E>(tag: String? = nil) -> (A, B, C, D, E) -> Void {
//        { (a: A, b: B, c: C, d: D, e: E) in
//            output("a = \(a), b = \(b), c = \(c), d = \(d), e = \(e)")
//        }
//    }

    // ----------------------------------------------------------------------------------

    // funcs that return something.
    // this only makes sense for wrapping funcs?
    // and not for shimming actions which was the first use case.

//    public func callAsFunction<A, B, Z>(f: @escaping (A, B) -> Z, tag: String? = nil) -> (A, B) -> Z where Z: Emptoid {
    public func callAsFunction<P1, P2, R1>(f: @escaping (P1, P2) -> R1, tag: String? = nil) -> (P1, P2) -> R1 {
//        func internalo(a: A, b: B, z1: Z = Z.emptoid, z2: Z = Z.emptoid) -> Z {
//        func internalo(a: A, b: B) -> Z {
//            let retZ = f(a, b)
//            output("a = \(a), b = \(b)")
//            return retZ
//        }

        { (p1: P1, p2: P2) -> R1 in

            let ret = f(p1, p2)
            output("P1 = \(p1), P2 = \(p2)")
            return ret
        }
//        return internalo
    }

    public func callAsFunction<P1, P2, R1, R2>(f: @escaping (P1, P2) -> (R1, R2), tag: String? = nil) -> (P1, P2) -> (R1, R2) {
//        func internalo(a: A, b: B, z1: Z = Z.emptoid, z2: Z = Z.emptoid) -> Z {
//        func internalo(a: A, b: B) -> Z {
//            let retZ = f(a, b)
//            output("a = \(a), b = \(b)")
//            return retZ
//        }

        { (p1: P1, p2: P2) -> (R1, R2) in

            let ret = f(p1, p2)
            output("P1 = \(p1), P2 = \(p2)")
            return ret
        }
//        return internalo
    }

    //    public func callAsFunction<A, B, Z>(f: (A, B) -> Z, tag: String? = nil) -> (A, B) -> Z {
//        { (a: A, b: B) -> Z in
//
//            let retZ = f(a, b)
//            output("a = \(a), b = \(b)")
//            return retZ
//        }
//    }
}


public func __iPrint<P1>(tag: String? = nil) -> (P1) -> Void {
    { (p1: P1) in
        print("P1 = \(p1)")
    }
}

//public func __iWrap<P1>(tag: String? = nil, f: @escaping (P1) -> Void) -> (P1) -> Void {
public func __iPrint<P1>(tag: String? = nil, f: @escaping (P1) -> Void) -> (P1) -> Void {
    { (p1: P1) in
        f(p1)
        print("P1 = \(p1)")
    }
}

//public func __iWrap<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {
public func __iPrint<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = f(p1)
        print("P1 = \(p1), Returns = \(ret)")
        return ret
    }
}

public protocol DefaultValueProviding {
    static var defaultValue: Self { get }
}

extension Int: DefaultValueProviding {
    public static var defaultValue = 0
}

public func __iAssertNotCalled<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 where R1: DefaultValueProviding {
    { (p1: P1) in
        assertionFailure("An __iAssertNotCalled was called")
        return R1.defaultValue
    }
}

public func __iAssertCalled<P1, R1>(tag: String? = "none", timeout: Double = 1.0, callFunc: String = #function, f: @escaping (P1) -> R1) -> (P1) -> R1 where R1: DefaultValueProviding {
    // use timer to wait for delay, then signal we weren't called.
    // if our block is called, we cancel the timer, and all is well.

    var timer: Timer?

    // Create a timer that fires after 1 second
    timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
        assertionFailure("Intercept: The closure for [callFunc: \(callFunc), tag: \(String(describing: tag))] was not called after \(timeout) seconds had elapsed")
    }

    return { (p1: P1) in
        timer?.invalidate()
        timer = nil
        return R1.defaultValue
    }
}

print("DONE3")

public func __iCalledAsync<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 where R1: DefaultValueProviding {
    { (p1: P1) in
        assertionFailure("An __iAssertNotCalled was called")
        return R1.defaultValue
    }
}

//f: @escaping (P1, P2) -> R1

let innerClosureAsVar = { (x: Int) in
    return
}

// structured concurrency must have a Task (or other structured context)
Task {
    print("Pre-sleep")
    // so we don't need async variant? or throws?
    // need to think about the throws bit
    await someThingAsync(__iPrint { x in
        return
    })
    print("Post-sleep")
    someThing(__iPrint { x in
        return
    })
    // works too, of course
    someThing(__iPrint(f: innerClosureAsVar))
    // without my iPrint
    someThing(innerClosureAsVar)
    print("Post-sync variant")

    try someThingThrows(__iPrint { x in
        return
    })

    PlaygroundPage.current.needsIndefiniteExecution = false
}


func someThing(_ f: (Int) -> Void) {
    f(7)
}

func someThingAsync(_ f: @escaping (Int) -> Void) async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    f(7)
}

func someThingThrows(_ f: @escaping (Int) throws -> Void) throws {
    try f(7)
    throw "Goober error"
}

func someThingDoesNotCall(_ f: (Int) -> Int) -> Int {
    // don't call f
    Int.defaultValue
}

func someThing(_ f: (Int) -> Int) -> Int {
    f(7)
}

func someThing2(_ f: (Int, String) -> CGFloat) {
    let ret = f(8, "bye")
    print(ret)
}

func someThing3(_ f: (Int, String) -> (CGFloat, CGFloat)) {
    let ret = f(8, "bye")
    print(ret)
}


//var iPrint = <P1, R1>{  }

//prefix operator ++
//
//prefix func ++ <P1, R1>(f: @escaping (P1) -> R1) -> (P1) -> R1 {
//    { p1 in
//        f(p1)
//    }
//}

//let ff =
//let x: Int = someThing(__iPrint)

someThing(__iPrint { x in
    12
})



//someThing(__iPrint)
someThing(__iPrint())

someThing(__iPrint() { p in
    print("In my actual func! got p = \(p)")
})

// these work:

// if detect unit test context? do the unit test type assertions? is this possible?

let x: Int = someThingDoesNotCall(__iAssertNotCalled() { p in
    print("In my actual func 2! got p = \(p)")
    return 5
})

let x2: Int = someThing(__iAssertCalled() { p in
    print("In my actual func 2! got p = \(p)")
    return 5
})

// this crashes out, as expected

//let x3: Int = someThingDoesNotCall(__iCalled() { p in
//    print("In my actual func 3! got p = \(p)")
//    return 5
//})

// this crashes out, as expected

//let x3: Int = someThingDoesNotCall(__iCalled(timeout: 0.5) { p in
//    print("In my actual func 3! got p = \(p)")
//    return 5
//})

// this crashes out, as expected
//let x4: Int = someThing(__iAssertNotCalled() { p in
//    print("In my actual func 4! got p = \(p)")
//    return 5
//})


// don't actually need this, the thread hangs around and does its thing
//sleep(2)
print("Exiting PG")

//someThing(ClosureDebug()())
//
//
//someThing2(ClosureDebug()(f:
//                            { (a: Int, b: String) -> CGFloat in
//                                return CGFloat(9.0)
//                            }
//                         )
//)
//
//someThing3(ClosureDebug()(f:
//                            { (a: Int, b: String) -> (CGFloat, CGFloat) in
//                                return (CGFloat(9.0), CGFloat(2.0))
//                            }
//                         )
//)

//public protocol Emptoid: Any {
//    static var emptoid: Self { get }
//}
//
//extension CGFloat: Emptoid {
//    public static var emptoid = CGFloat(0.0)
//}

//Can i get throw ?. optError to be a thing?

// do I need to wrap throw somehow to access as func for my .? thing?
//print(throw)

infix operator .?

func .? <P1>(lhs: @escaping (P1) throws -> Void, rhs: Optional<P1>) rethrows -> Void {
    if let rhs {
        try lhs(rhs)
    }
}

func .? <P1>(lhs: @escaping (P1) -> Void, rhs: Optional<P1>) -> Void {
    if let rhs {
        lhs(rhs)
    }
}

//extension Error: String { }
extension String: Error { }

let e: Error? = "adsad"

let c = { x in print(x) }

//throw .? e

let optInt: Int? = 6

c .? optInt

do {
    try tthrow .? e
}
catch {
    print(">>> Caught the error \(error)")
}

// might as well just have maybeThrow as a func, if we have to wrap it like this anyway!
// (see further below)
func tthrow(e: Error) throws {
    throw(e)
}

// ... like so:
func maybeThrow(e: Error?) throws {
    if let e {
        throw(e)
    }
}



prefix operator .?

prefix func .? <P1, R1>(f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { p1 in
        f(p1)
    }
}


// don't forget the throws and async variants too

