//
//  LogSpy.swift
//  SwiftInterposeTests
//
//  Created by Alex Hunsley on 02/07/2024.
//

import Foundation

// mutating stuff when using struct... use class for now,
// look at this later
class LogSpy {
    public var seen_strings = [String]()

    func log(str: String) {
        seen_strings.append(str)
    }
}
