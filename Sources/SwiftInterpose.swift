import Foundation

public protocol DefaultValueProviding {
    static var defaultValue: Self { get }
}

extension Int: DefaultValueProviding {
    public static var defaultValue = 0
}


public struct Interpose {
    public typealias FormattedDateProvider = () -> String
    public typealias LoggingProvider = (String) -> Void
    public typealias AssertFailProvider = (String) -> Void

    /// -----------------------

    public static let defaultDateProvider: FormattedDateProvider = {
        "\(Date())"
    }

    public static let mockDateProvider: FormattedDateProvider = {
        "[Date mock]"
    }

    public static var dateProvider: FormattedDateProvider = Interpose.defaultDateProvider

    /// -----------------------

    // need way to pass in logger, but not call it!
    // as need to call log instead to prep the string with e.g. prefix.
    //   fileprivate as stuff in module namespace in this file needs
    // access. but not from elsewhere.
    //
    // ok making logger be internal as _logger, and this protects from
    // user trying to call directly.
//    static var logger: LoggingProvider = Interpose.defaultLogger
    public static var logger: LoggingProvider {
        get {
            // guardrail against us using this instead of `log`.
            // Necessary because .log decorates the log string with e.g. function name etc.
            { _ in
                assertionFailure("Interpose error: do not call Interpose.logger; instead use Interpose.log.")
            }
        }
        set {
            Interpose._logger = newValue
        }
    }
    static var _logger: LoggingProvider = Interpose.defaultLogger

    public static let defaultLogger: LoggingProvider = { str in
        print("hjhj IN DEFAULT LOGGER")
        print("\(Interpose.logPrefix()) \(str)")
    }

    /// ----------------------------------------------------------------------------------------

    public static var assertFailer: AssertFailProvider {
        get {
            // guardrail against us using this instead of `log`.
            // Necessary because .log decorates the log string with e.g. function name etc.
            { _ in
                assertionFailure("Interpose error: do not call Interpose.asserter; instead use Interpose.assert.")
            }
        }
        set {
            Interpose._assertFailer = newValue
        }
    }
    static var _assertFailer: AssertFailProvider = Interpose.defaultAssertFailer

    public static let defaultAssertFailer: AssertFailProvider = { str in
        print("\(Interpose.logPrefix()) \(str)")
        assertionFailure(str)
    }


    /// -----------------------

    fileprivate static func logPrefix() -> [String] {
        return ["\(Interpose.dateProvider())"]
    }

//    public static func log(str: String) {
//        Interpose.logger("\(Interpose.logPrefix()) \(str)")
//    }

    // log execution
    public static let log = { (strs: [String]) in
        _logger(buildLogStr(forStrings: strs))
    }

    // assert fail execution
    public static let assertionFail = { (strs: [String]) in
        _assertFailer(buildLogStr(forStrings: strs))
    }
//
//    public static let assertFail = { (strs: [String]) in
//        _logger(buildLogStr(forStrings: strs))
//    }

    private static func buildLogStr(forStrings strs: [String]) -> String {
        // remove empty strings to avoid repeated space chars in log string
        let logEntryComponents: [String] = Interpose.logPrefix() + strs
            .filter { !$0.isEmpty }

        return String(logEntryComponents.joined(separator: " "))
    }
}

//public func __iPrint(tag: String? = nil,
//                     logger: @escaping (String) -> Void = __iPrintLogger,
//                     dateProvider: @escaping Interpose.FormattedDateProvider = Interpose.dateProvider) -> () -> Void {
public func __iPrint(tag: String? = nil) -> () -> Void {
    {
        print("hjhj calling Interpose.logger with tag bit = |\(tag ?? "")|")
//        Interpose.log(["\(tag ?? "")"])
        Interpose.log([tag ?? ""])
    }
}

public func __iPrint(tag: String? = nil,
                     f: @escaping () -> Void) -> () -> Void {
    {
        f()
//        Interpose.log("\(tag ?? "")")
        Interpose.log([tag ?? ""])
    }
}

/// ----------------------
///
///
public func __iPrint<P1>(tag: String? = nil) -> (P1) -> Void {
    { (p1: P1) in
        Interpose.log(["\(tag ?? "")", "P1 = \(p1)"])
    }
}

public func __iPrint<P1>(tag: String? = nil,
                         f: @escaping (P1) -> Void) -> (P1) -> Void {
    { (p1: P1) in
        f(p1)
        Interpose.log(["P1 = \(p1)"])
    }
}

//public func __iWrap<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {
public func __iPrint<P1, R1>(tag: String? = nil,
                             f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = f(p1)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns = \(ret)"])
        return ret
    }
}

// -------------------------------

public func __iAssertNeverCalled(tag: String? = nil, callFunc: String = #function, callFile: String = #file) -> () -> Void {
    {
        Interpose.assertionFail([tag ?? "", "\(Interpose.dateProvider())"])
    }
}

public func __iAssertCalled(tag: String? = nil, callFunc: String = #function, callFile: String = #file) -> () -> Void {
    let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
        print("QPQP __iAssertCalled timer popped, so asserting!")
        Interpose.assertionFail([tag ?? "", "\(Interpose.dateProvider())"])
    }

    return {
        print("QPQP __iAssertCalled timer.invalidate()")
        timer.invalidate()
    }
}

// and an XCTAssert version for unit tests?
