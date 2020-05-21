import XCTest

import OptionalAPITests

var tests = [XCTestCaseEntry]()
tests += OptionalAPITests.allTests()
XCTMain(tests)
