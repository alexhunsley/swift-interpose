import UIKit


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

func someThing(_ f: (Int) -> Void) {
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

someThing(ClosureDebug()())

someThing2(ClosureDebug()(f:
                            { (a: Int, b: String) -> CGFloat in
                                return CGFloat(9.0)
                            }
                         )
)

someThing3(ClosureDebug()(f:
                            { (a: Int, b: String) -> (CGFloat, CGFloat) in
                                return (CGFloat(9.0), CGFloat(2.0))
                            }
                         )
)

//public protocol Emptoid: Any {
//    static var emptoid: Self { get }
//}
//
//extension CGFloat: Emptoid {
//    public static var emptoid = CGFloat(0.0)
//}
