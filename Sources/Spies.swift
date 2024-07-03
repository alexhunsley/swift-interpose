//
//  Spies.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

// NOTE: we don't make our f funcs be optional, and handle
// them being present or not (nil) in one place, because
// otherwise we'd always have to do DefaultValueProviding,
// even if just doing a spy (i.e. when there was no need for default values!)

// MARK: - 0 in spies

// Spy (0 in 0 out)
public func __iPrint(tag: String? = nil,
                     f: @escaping () -> Void) -> () -> Void {
    {
        f()
        Interpose.log([tag ?? ""])
    }
}

// Spy (0 in 1 out)
public func __iPrint<R1>(tag: String? = nil,
                         f: @escaping () -> R1) -> () -> R1 {
    {
        let ret = f()
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "Returns = \(ret)"])
        return ret
    }
}

// Spy (0 in 2 out)
public func __iPrint<R1, R2>(tag: String? = nil,
                         f: @escaping () -> (R1, R2)) -> () -> (R1, R2) {
    {
        let ret = f()
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "Returns = \(ret)"])
        return ret
    }
}

// MARK: - 1 in spies

// Spy (1 in 0 out)
public func __iPrint<P1>(tag: String? = nil,
                         f: @escaping (P1) -> Void) -> (P1) -> Void {
    { (p1: P1) in
        f(p1)
        Interpose.log(["P1 = \(p1)"])
    }
}

// Spy (1 in 1 out)
public func __iPrint<P1, R1>(tag: String? = nil,
                             f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = f(p1)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns = \(ret)"])
        return ret
    }
}

// Spy (1 in 2 out)
public func __iPrint<P1, R1, R2>(tag: String? = nil,
                                 f: @escaping (P1) -> (R1, R2)) -> (P1) -> (R1, R2) {
    { (p1: P1) in
        let ret = f(p1)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns = \(ret)"])
        return ret
    }
}

// MARK: - 2 in spies

// Spy (2 in 0 out)
public func __iPrint<P1, P2>(tag: String? = nil,
                             f: @escaping (P1, P2) -> Void) -> (P1, P2) -> Void {
    { (p1: P1, p2: P2) in
        f(p1, p2)
        Interpose.log(["P1 = \(p1) \(p2)"])
    }
}

// Spy (2 in 1 out)
public func __iPrint<P1, P2, R1>(tag: String? = nil,
                                 f: @escaping (P1, P2) -> R1) -> (P1, P2) -> R1 {
    { (p1: P1, p2: P2) in
        let ret = f(p1, p2)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1) P2 = \(p2), Returns = \(ret)"])
        return ret
    }
}

// Spy (2 in 2 out)
public func __iPrint<P1, P2, R1, R2>(tag: String? = nil,
                                     f: @escaping (P1, P2) -> (R1, R2)) -> (P1, P2) -> (R1, R2) {
    { (p1: P1, p2: P2) in
        let ret = f(p1, p2)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1) P2 = \(p2), Returns = \(ret)"])
        return ret
    }
}
