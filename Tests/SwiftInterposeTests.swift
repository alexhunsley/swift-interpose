// hello

import XCTest
import SwiftInterpose

typealias VoidInVoidOut = () -> Void
typealias IntInVoidOut = (Int) -> Void

class InterposeTests: XCTestCase {

    var logStub: LogStub!

    override func setUp() {
        logStub = LogStub()
    }

    override func tearDown() {
        logStub = nil
    }

    // the 'dummy' use case is using iPrint without an inner handler
    func test_voidInVoidOut_asDummy_invokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logStub.seen_strings, [])

        takeVoidInVoidOutAndInvoke(handler: __iPrint(logger: logStub.log))

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logStub.seen_strings, [" "])

        takeVoidInVoidOutAndInvoke(handler: __iPrint(tag: "tag1",
                                                     logger: logStub.log))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logStub.seen_strings, [" ", "tag1 "])

    }

    // the 'dummy' use case is using iPrint without an inner handler
    func test_voidInVoidOut_asShim_invokesTargetHandler_andInvokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logStub.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        takeVoidInVoidOutAndInvoke(handler: __iPrint(logger: logStub.log) {
            // this is the 'real' handler
            print("Real handler, void")
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.2)

        XCTAssertEqual(logStub.seen_strings, [" "])
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

        XCTAssertEqual(logStub.seen_strings, ["helloTag "])
    }


    func test_intInVoidOut_asDummy_invokesLogger() throws {
        //        takeIntInVoidOut { __iPrint<P1>(tag: "tag1",
        //                                        logger: logStub)
        //        }

        //        takeIntInVoidOut(handler: __iPrint(tag: "tag1"))

        takeIntInVoidOutAndInvoke(handler: { i in })

        // expect that our log stub is not invoked
        //        let seen_str = try XCTUnwrap(logStub.seen_string)
        XCTAssertEqual(logStub.seen_strings, [])

        takeIntInVoidOutAndInvoke(handler: __iPrint(logger: logStub.log))

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logStub.seen_strings, [" P1 = 2"])

        takeIntInVoidOutAndInvoke(handler: __iPrint(tag: "tag1",
                                                    logger: logStub.log))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logStub.seen_strings, [" P1 = 2", "tag1 P1 = 2"])
    }

    func test_intInVoidOut_asDummy_invokesLoggerTwice() throws {
        //        takeIntInVoidOut { __iPrint<P1>(tag: "tag1",
        //                                        logger: logStub)
        //        }

        //        takeIntInVoidOut(handler: __iPrint(tag: "tag1"))

        takeIntInVoidOutAndInvokeTwice(handler: { i in })

        // expect that our log stub is not invoked
        //        let seen_str = try XCTUnwrap(logStub.seen_string)
        XCTAssertEqual(logStub.seen_strings, [])

        takeIntInVoidOutAndInvokeTwice(handler: __iPrint(logger: logStub.log))

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logStub.seen_strings, [" P1 = 3", " P1 = 4"])

        takeIntInVoidOutAndInvoke(handler: __iPrint(tag: "tag1",
                                                    logger: logStub.log))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logStub.seen_strings, [" P1 = 3", " P1 = 4", "tag1 P1 = 2"])
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

// mutating stuff when using struct...
class LogStub {
    public var seen_strings = [String]()
//    public let log: (String) -> Void

    public init() {
//        log = { (str: String) -> Void in
//            seen_string = str
//        }
    }

    func log(str: String) {
        seen_strings.append(str)
    }
}
