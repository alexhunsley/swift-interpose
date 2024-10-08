// hello

import XCTest
@testable import SwiftInterpose

class InterposeTests: XCTestCase {

    var logSpy: LogSpy!
    private let expectationTimeout: CGFloat = 0.5

    override func setUp() {
        logSpy = LogSpy()
        Interpose.logger = logSpy.log
        Interpose.dateProvider = Interpose.mockDateProvider
    }

    override func tearDown() {
        logSpy = nil
        Interpose.logger = Interpose.defaultLogger
        Interpose.dateProvider = Interpose.defaultDateProvider
    }

    /// -----------------------------------------------------------------------------------------------------------------
    // MARK: - Dummy tests

    // the 'dummy' use case is using iPrint without an inner handler
    func test_voidInVoidOut_asDummy_invokesLogger() throws {
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

    func test_voidInStringOut_asDummy_invokesLogger_andUsesDefaultValue() throws {
        let returnedString = takeIntInStringOutAndInvoke(handler: __iPrint())
        XCTAssertEqual(returnedString, String.defaultValue)
    }

    func test_voidInStringOut_asSpy_invokesLogger_andUsesDefaultValue() throws {
        let returnedString = takeIntInStringOutAndInvoke(intValue: 7, handler: __iPrint { integer in
            "a returned string \(integer)"
        })
        XCTAssertEqual(returnedString, "a returned string 7")
    }
    
    func test_voidInStringOut_asSpy_recordsData() throws {
        let returnedString = takeIntInStringOutAndInvoke(intValue: 7, handler: __iPrint(tag: "recordingTest") { integer in // herus. add a tag and check the record!
            "a returned string \(integer)"
        })
        XCTAssertEqual(returnedString, "a returned string 7")

        let returnedString2 = takeIntInStringOutAndInvoke(intValue: 11, handler: __iPrint(tag: "recordingTest-distinct") { integer in // herus. add a tag and check the record!
            "a returned string \(integer)"
        })
        XCTAssertEqual(returnedString2, "a returned string 11")

        XCTAssertEqual(Interpose.default.records.count, 2)

        let record = try XCTUnwrap(Interpose.default.records["recordingTest"] as? Interpose.IRecord<Int, String>)
        XCTAssertEqual(record, Interpose.IRecord(p1: 7, r1: "a returned string 7"))

        let record2 = try XCTUnwrap(Interpose.default.records["recordingTest-distinct"] as? Interpose.IRecord<Int, String>)
        XCTAssertEqual(record2, Interpose.IRecord(p1: 11, r1: "a returned string 11"))
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

    /// -----------------------------------------------------------------------------------------------------------------
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

    /// -----------------------------------------------------------------------------------------------------------------
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

    /// -----------------------------------------------------------------------------------------------------------------
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
}
