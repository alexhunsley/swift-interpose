// hello

import XCTest
import SwiftInterpose

// rename logger to something more general?
// secretAgent? :)
class InterposeTests: XCTestCase {

    var logSpy: LogSpy!
    private let expectationTimeout: CGFloat = 1.0

    override func setUp() {
        logSpy = LogSpy()
        // logStub.log doens't contain the prefix bit, etc!
        // could have attachLogger? For multiples. Getting a bit complicated there...!
        Interpose.logger = logSpy.log
        Interpose.dateProvider = Interpose.mockDateProvider
    }

    override func tearDown() {
        logSpy = nil
        Interpose.logger = Interpose.defaultLogger
        Interpose.dateProvider = Interpose.defaultDateProvider
    }

    // MARK: - Dummy tests

    // the 'dummy' use case is using iPrint without an inner handler
    func test_voidInVoidOut_asDummy_invokesLogger() throws {
        // the whole throws bit is interesting. How to handle that
        // with my interpose bit? In particular, if my assert wants to throw
        // to indicate assert failed? Is it possible (or advisable)?
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logSpy.seen_strings, [])

        takeVoidInVoidOutAndInvoke(handler: __iPrint())

        XCTAssertEqual(logSpy.seen_strings, ["[Date mock]"])
    }

    func test_intInVoidOut_asDummy_invokesLogger() throws {
        takeIntInVoidOutAndInvoke(handler: { i in })

        // expect that our log stub is not invoked
        XCTAssertEqual(logSpy.seen_strings, [])

        takeIntInVoidOutAndInvoke(handler: __iPrint())

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logSpy.seen_strings, ["[Date mock] P1 = 2"])

        takeIntInVoidOutAndInvoke(handler: __iPrint(tag: "tag1"))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logSpy.seen_strings, ["[Date mock] P1 = 2", "[Date mock] tag1 P1 = 2"])
    }

    func test_intInVoidOut_asDummy_invokesLoggerTwice() throws {
        takeIntInVoidOutAndInvokeTwice(handler: { i in })

        // expect that our log stub is not invoked
        XCTAssertEqual(logSpy.seen_strings, [])

        takeIntInVoidOutAndInvokeTwice(handler: __iPrint())

        // expect that our log stub is invoked (no tag)
        XCTAssertEqual(logSpy.seen_strings, ["[Date mock] P1 = 3", "[Date mock] P1 = 4"])

        takeIntInVoidOutAndInvoke(handler: __iPrint(tag: "tag1"))

        // expect that our log stub is invoked (with tag)
        XCTAssertEqual(logSpy.seen_strings, ["[Date mock] P1 = 3", "[Date mock] P1 = 4", "[Date mock] tag1 P1 = 2"])
    }

    // MARK: - Shim tests

    func test_voidInVoidOut_asShim_invokesTargetHandler_andInvokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logSpy.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        takeVoidInVoidOutAndInvoke(handler: __iPrint {
            // this is the 'real' handler
            expectation.fulfill()
        })

        waitForExpectations(timeout: expectationTimeout)

        XCTAssertEqual(logSpy.seen_strings, ["[Date mock]"])
    }

    func test_asyncVoidInVoidOut_asShim_invokesTargetHandler_andInvokesLogger() async throws {
        await takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logSpy.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        await takeVoidInVoidOutAndInvoke(handler: __iPrint {
            // this is the 'real' handler
            expectation.fulfill()
        })

        await fulfillment(of: [expectation], timeout: expectationTimeout)

        XCTAssertEqual(logSpy.seen_strings, ["[Date mock]"])
    }

    func test_voidInVoidOut_asShim_withTag_invokesTargetHandler_andInvokesLogger() throws {
        takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logSpy.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        takeVoidInVoidOutAndInvoke(handler: __iPrint(tag: "helloTag") {
            // this is the 'real' handler
            print("Real handler, void")
            expectation.fulfill()
        })

        waitForExpectations(timeout: expectationTimeout)

        XCTAssertEqual(logSpy.seen_strings, ["[Date mock] helloTag"])
    }

    func test_asyncVoidInVoidOut_asShim_withTag_invokesTargetHandler_andInvokesLogger() async throws {
        await takeVoidInVoidOutAndInvoke(handler: { })

        XCTAssertEqual(logSpy.seen_strings, [])

        let expectation = expectation(description: "target handler is invoked")

        await takeVoidInVoidOutAndInvoke(handler: __iPrint(tag: "helloTag") {
            // this is the 'real' handler
            expectation.fulfill()
        })

        await fulfillment(of: [expectation], timeout: expectationTimeout)

        XCTAssertEqual(logSpy.seen_strings, ["[Date mock] helloTag"])
    }

    // MARK: - __iAssertNeverCalled

    func test_assertNeverCallWhenCalled() {
        let expectation = expectation(description: "asserted is called")

        Interpose.assertFailer = { str in
            expectation.fulfill()
        }
        takeVoidInVoidOutAndInvoke(handler: __iAssertNeverCalled())
        waitForExpectations(timeout: expectationTimeout)
    }

    func test_asyncAssertNeverCallWhenCalled() async {
        let expectation = expectation(description: "asserted is called")

        Interpose.assertFailer = { str in
            expectation.fulfill()
        }
        await takeVoidInVoidOutAndInvoke(handler: __iAssertNeverCalled())
        await fulfillment(of: [expectation], timeout: expectationTimeout)
    }

    func test_assertNeverCallWhenNotCalled() {
        let expectation = expectation(description: "asserted is not called")
        expectation.isInverted = true

        Interpose.assertFailer = { str in
            expectation.fulfill()
        }
        takeVoidInVoidOutAndDoNotInvoke(handler: __iAssertNeverCalled())
        waitForExpectations(timeout: expectationTimeout)
    }

    func test_asyncAssertNeverCallWhenNotCalled() async {
        let expectation = expectation(description: "asserted is not called")
        expectation.isInverted = true

        Interpose.assertFailer = { str in
            expectation.fulfill()
        }
        await takeVoidInVoidOutAndDoNotInvoke(handler: __iAssertNeverCalled())
        await fulfillment(of: [expectation], timeout: expectationTimeout)
    }

    // MARK: - __iAssertCalled

    func test_assertCallWhenCalled() {
        let expectation = expectation(description: "asserted is not called")
        expectation.isInverted = true

        Interpose.assertFailer = { str in
            expectation.fulfill()
        }
        takeVoidInVoidOutAndInvoke(handler: __iAssertCalled())
        waitForExpectations(timeout: expectationTimeout)
    }

    func test_assertCallWhenNotCalled() {
        let expectation = expectation(description: "asserted is called")

        Interpose.assertFailer = { str in
            expectation.fulfill()
        }
        takeVoidInVoidOutAndDoNotInvoke(handler: __iAssertCalled())
        waitForExpectations(timeout: expectationTimeout)
    }

    // use the PF concurrency tool to avoid actual sleeps? In the tests only?
}
