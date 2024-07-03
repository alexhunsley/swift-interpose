//
//  DefaultValue.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation


public protocol DefaultValueProviding {
    static var defaultValue: Self { get }
}

extension Int: DefaultValueProviding {
    public static var defaultValue = 0
}

extension CGFloat: DefaultValueProviding {
    public static var defaultValue = CGFloat.zero
}

extension Double: DefaultValueProviding {
    public static var defaultValue = 0.0
}

extension String: DefaultValueProviding {
    public static var defaultValue = ""
}

extension Date: DefaultValueProviding {
    public static var defaultValue = Date.distantFuture
}

//extension Optional: DefaultValueProviding {
////  "Static stored properties not supported in generic types"
//    public static var defaultValue = Optional<Wrapped>.none
//}
//
//extension ClosedRange: DefaultValueProviding {
//    public static var defaultValue = 0..<1
//}
