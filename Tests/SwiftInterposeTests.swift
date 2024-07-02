// hello

import XCTest
import SwiftInterpose

// sort out the spaces in strings!

typealias VoidInVoidOut = () -> Void
typealias IntInVoidOut = (Int) -> Void

class InterposeTests: XCTestCase {

    var logStub: LogStub!

    override func setUp() {
        logStub = LogStub()
        // logStub.log doens't contain the prefix bit, etc!
        // could have attachLogger? For multiples. Getting a bit complicated there...!
        Interpose.logger = logStub.log
        Interpose.dateProvider = Interpose.mockDateProvider
    }

    override func tearDown() {
        logStub = nil
        Interpose.logger = Interpose.defaultLogger
        Interpose.dateProvider = Interpose.defaultDateProvider
    }

    // the 'dummy' use case is using iPrint without an inner handler
    func test_voidInVoidOut_asDummy_invokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logStub.seen_strings, [])

        takeVoidInVoidOutAndInvoke(handler: __iPrint())

        XCTAssertEqual(logStub.seen_strings, ["[Date mock]"])

//        takeVoidInVoidOutAndInvoke(handler: __iPrint(tag: "tag1"))
//
//        // expect that our log stub is invoked (with tag)
//        XCTAssertEqual(logStub.seen_strings, [" [Date mock] ", " tag1 [Date mock] "])

    }

    // the 'dummy' use case is using iPrint without an inner handler
    func test_voidInVoidOut_asShim_invokesTargetHandler_andInvokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logStub.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        takeVoidInVoidOutAndInvoke(handler: __iPrint(logger: logStub.log) {
            // this is the 'real' handler
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.2)

        XCTAssertEqual(logStub.seen_strings, ["[Date mock]"])
    }

    func test_voidInVoidOut_asShim_withTag_invokesTargetHandler_andInvokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logStub.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        takeVoidInVoidOutAndInvoke(handler: __iPrint(tag: "helloTag", logger: logStub.log) {
            // this is the 'real' handler
            print("Real handler, void")
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.2)

        XCTAssertEqual(logStub.seen_strings, ["[Date mock] helloTag"])
    }


    func test_intInVoidOut_asDummy_invokesLogger() throws {
        takeIntInVoidOutAndInvoke(handler: { i in })

        // expect that our log stub is not invoked
        XCTAssertEqual(logStub.seen_strings, [])

        takeIntInVoidOutAndInvoke(handler: __iPrint())

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logStub.seen_strings, ["[Date mock] P1 = 2"])

        takeIntInVoidOutAndInvoke(handler: __iPrint(tag: "tag1"))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logStub.seen_strings, ["[Date mock] P1 = 2", "[Date mock] tag1 P1 = 2"])
    }

    func test_intInVoidOut_asDummy_invokesLoggerTwice() throws {
        takeIntInVoidOutAndInvokeTwice(handler: { i in })

        // expect that our log stub is not invoked
        XCTAssertEqual(logStub.seen_strings, [])

        takeIntInVoidOutAndInvokeTwice(handler: __iPrint())

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logStub.seen_strings, ["[Date mock] P1 = 3", "[Date mock] P1 = 4"])

        takeIntInVoidOutAndInvoke(handler: __iPrint(tag: "tag1"))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logStub.seen_strings, ["[Date mock] P1 = 3", "[Date mock] P1 = 4", "[Date mock] tag1 P1 = 2"])
    }

    // MARK: - Helper funcs / closures

    let voidInVoidOut = {
        print("voidInVoidOut")
    }

    let intInVoidOut = { (i: Int) in
        print("intInVoidOut got \(i)")
    }

    func takeVoidInVoidOutAndInvoke(handler: VoidInVoidOut) {
        handler()
    }

    func takeIntInVoidOutAndInvoke(handler: IntInVoidOut) {
        handler(2)
    }

    func takeIntInVoidOutAndInvokeTwice(handler: IntInVoidOut) {
        handler(3)
        handler(4)
    }
}

// mutating stuff when using struct... use class for now,
// look at this later
class LogStub {
    public var seen_strings = [String]()

    func log(str: String) {
        seen_strings.append(str)
    }
}
