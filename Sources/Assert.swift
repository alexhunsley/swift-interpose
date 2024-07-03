//
//  Assert.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

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
