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

//    var voidInVoidOut: VoidVoid {
//        {
//            let _ = print("voidInVoidOut")
//        }
//    }

//    var intInVoidOut: (Int) -> Void {
//        { (i: Int) in
//            let _ = print("intInVoidOut got \(i)")
//        }
//    }

    // Interesting things:
    //
    // you can overload a func just on having async and no async.
    // We use `syncTag` is just a marker so the async version of method can call the async one
    // without ambiguity.

    // MARK: - 0 in 0 out, no invoke

    func takeVoidInVoidOutAndDoNotInvoke(handler: VoidVoid, syncTag: Never? = nil) rethrows {
    }
    
    func takeVoidInVoidOutAndDoNotInvoke(handler: VoidVoid) async rethrows {
        try takeVoidInVoidOutAndDoNotInvoke(handler: handler, syncTag: nil)
    }

    // MARK: - 0 in 0 out, invoke

    func takeVoidInVoidOutAndInvoke(handler: VoidVoid, syncTag: Never? = nil) rethrows {
        try handler()
    }

    func takeVoidInVoidOutAndInvoke(handler: VoidVoid) async rethrows {
        try takeVoidInVoidOutAndInvoke(handler: handler, syncTag: nil)
    }

    // MARK: - 1 in 0 out, invoke

    func takeIntInVoidOutAndInvoke(handler: IntVoid, syncTag: Never? = nil) rethrows {
        try handler(2)
    }

    func takeIntInVoidOutAndInvoke(handler: IntVoid) async rethrows {
        try takeIntInVoidOutAndInvoke(handler: handler, syncTag: nil)
    }

    // MARK: - 1 in 0 out, invoke twice

    func takeIntInVoidOutAndInvokeTwice(handler: IntVoid, syncTag: Never? = nil) rethrows {
        try handler(3)
        try handler(4)
    }

    func takeIntInVoidOutAndInvokeTwice(handler: IntVoid) async rethrows {
        try takeIntInVoidOutAndInvokeTwice(handler: handler, syncTag: nil)
    }
}
