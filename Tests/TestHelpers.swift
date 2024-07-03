//
//  TestHelpers.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

typealias VoidVoid = () throws -> Void
typealias AsyncVoidVoid = () async throws -> Void
typealias IntVoid = (Int) throws -> Void
typealias AsyncIntVoid = (Int) async throws -> Void

extension InterposeTests {
    // MARK: - Helper funcs / closures

    var voidInVoidOut: VoidVoid {
        {
            let _ = print("voidInVoidOut")
        }
    }

    var intInVoidOut: (Int) -> Void {
        { (i: Int) in
            let _ = print("intInVoidOut got \(i)")
        }
    }

    func takeVoidInVoidOutAndDoNotInvoke(handler: VoidVoid) {
    }

    func takeVoidInVoidOutAndInvoke(handler: VoidVoid) rethrows {
        try handler()
    }

    func takeAsyncVoidInVoidOutAndInvoke(handler: @escaping AsyncVoidVoid) async rethrows {
        try await handler()
    }


    func takeIntInVoidOutAndInvoke(handler: IntVoid) rethrows {
        try handler(2)
    }

    func takeAsyncIntInVoidOutAndInvoke(handler: @escaping IntVoid) async rethrows {
        try handler(2)
    }

    func takeIntInVoidOutAndInvokeTwice(handler: IntVoid) rethrows {
        try handler(3)
        try handler(4)
    }

    func takeAsyncIntInVoidOutAndInvokeTwice(handler: @escaping AsyncIntVoid) async rethrows {
        try await handler(3)
        try await handler(4)
    }
}
