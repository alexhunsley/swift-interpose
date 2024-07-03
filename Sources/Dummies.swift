//
//  Dummies.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

// MARK: - 0 in dummies

// Dummy (0 in 0 out)
public func __iPrint(tag: String? = nil) -> () -> Void {
    {
        Interpose.log([tag ?? ""])
    }
}

// Dummy (0 in 1 out) -- returns some default values
public func __iPrint<R1: DefaultValueProviding>(tag: String? = nil) -> () -> R1 {
    {
        let ret = R1.defaultValue
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "Returns default values = \(ret)"])
        return ret
    }
}

// Dummy (0 in 2 out) -- returns some default values
public func __iPrint<R1: DefaultValueProviding, R2: DefaultValueProviding>(tag: String? = nil) -> () -> (R1, R2) {
    {
        let ret = (R1.defaultValue, R2.defaultValue)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "Returns default values = \(ret)"])
        return ret
    }
}

// MARK: - 1 in dummies

// Dummy (1 in 0 out)
public func __iPrint<P1>(tag: String? = nil) -> (P1) -> Void {
    { (p1: P1) in
        Interpose.log(["\(tag ?? "")", "P1 = \(p1)"])
    }
}


// Dummy (1 in 1 out) -- returns some default values
public func __iPrint<P1, R1: DefaultValueProviding>(tag: String? = nil) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = R1.defaultValue
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns default values = \(ret)"])
        return ret
    }
}

// Dummy (1 in 2 out) -- returns some default values
public func __iPrint<P1, R1: DefaultValueProviding, R2: DefaultValueProviding>(tag: String? = nil) -> (P1) -> (R1, R2) {
    { (p1: P1) in
        let ret = (R1.defaultValue, R2.defaultValue)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns default values = \(ret)"])
        return ret
    }
}

// MARK: - 2 in dummies

// Dummy (2 in 0 out)
public func __iPrint<P1, P2>(tag: String? = nil) -> (P1, P2) -> Void {
    { (p1: P1, p2: P2) in
        Interpose.log(["\(tag ?? "")", "P1 = \(p1), P2 = \(p2)"])
    }
}


// Dummy (2 in 1 out) -- returns some default values
public func __iPrint<P1, P2, R1: DefaultValueProviding>(tag: String? = nil) -> (P1, P2) -> R1 {
    { (p1: P1, p2: P2) in
        let ret = R1.defaultValue
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), P2 = \(p2), Returns default values = \(ret)"])
        return ret
    }
}

// Dummy (2 in 2 out) -- returns some default values
public func __iPrint<P1, P2, R1: DefaultValueProviding, R2: DefaultValueProviding>(tag: String? = nil) -> (P1, P2) -> (R1, R2) {
    { (p1: P1, p2: P2) in
        let ret = (R1.defaultValue, R2.defaultValue)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), P2 = \(p2), Returns default values = \(ret)"])
        return ret
    }
}
