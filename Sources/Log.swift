//
//  Log.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

extension Interpose {
    public typealias LoggingProvider = (String) -> Void

    static var _logger: LoggingProvider = Interpose.defaultLogger

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

    public static let defaultLogger: LoggingProvider = { str in
        print("hjhj IN DEFAULT LOGGER")
        print("\(Interpose.logPrefix()) \(str)")
    }

    // log execution
    public static let log = { (strs: [String]) in
        _logger(buildLogStr(forStrings: strs))
    }

    static func logPrefix() -> [String] {
        return ["\(Interpose.dateProvider())"]
    }

    static func buildLogStr(forStrings strs: [String]) -> String {
        // remove empty strings to avoid repeated space chars in log string
        let logEntryComponents: [String] = Interpose.logPrefix() + strs
            .filter { !$0.isEmpty }

        return String(logEntryComponents.joined(separator: " "))
    }
}
