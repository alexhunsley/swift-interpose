//
//  AssertionFailure.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

public extension Interpose {
    typealias AssertFailProvider = (String) -> Void

    static var _assertFailer: AssertFailProvider = Interpose.defaultAssertFailer

    static var assertFailer: AssertFailProvider {
        get {
            // guardrail against us using this instead of `log`.
            // Necessary because .log decorates the log string with e.g. function name etc.
            { _ in
                assertionFailure("Interpose error: do not call Interpose.assertFailer; instead use Interpose.assertionFail.")
            }
        }
        set {
            Interpose._assertFailer = newValue
        }
    }

    static let defaultAssertFailer: AssertFailProvider = { str in
        print("\(Interpose.logPrefix()) \(str)")
        assertionFailure(str)
    }

    static let assertionFail = { (strs: [String]) in
        _assertFailer(buildLogStr(forStrings: strs))
    }
}
