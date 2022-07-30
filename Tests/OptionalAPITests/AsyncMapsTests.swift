
import Foundation

import XCTest
import OptionalAPI


final class AsyncMapsTests: XCTestCase {

    // MARK: Map

    func test_asyncMap_whenNone_shouldNotCallTransform_andReturn_none() async {
        let none: Int? = .none

        let result: Void? = await none.asyncMap { _ in XCTFail( "Should not call this closure!" ) }

        XCTAssertNil( result )
    }

    func test_asyncMap_whenSome_shouldCallTransform_andReturn_expectedValue() async {
        let some: Int? = 42

        let result: Int? = await some.asyncMap { wrapped in
            try! await Task.sleep(nanoseconds: 42)
            return wrapped * 2
        }

        XCTAssertEqual(result, 84)
    }

    // MARK: Flat Map

    func test_asyncFlatMap_whenNone_shouldNotCallTransform_andReturn_none() async {
        let none: Int? = .none

        let result: Void? = await none.asyncFlatMap { _ in XCTFail( "Should not call this closure!" ) }

        XCTAssertNil( result )
    }

    func test_asyncFlatMap_whenSome_shouldCallTransform_andReturn_expectedValue() async {
        let some: Int? = 42

        let result: Int? = await some.asyncFlatMap { wrapped in
            try! await Task.sleep(nanoseconds: 42)
            return wrapped * 2
        }

        XCTAssertEqual(result, 84)
    }

    func test_asyncFlatMap_whenSome_whenTransformReturns_optionalValue_shouldReturnExpectedResult() async {
        let none: String? = "42"

        let result: Int? = await none.asyncFlatMap { (w: String) -> Int? in
            try! await Task.sleep(nanoseconds: 42)
            return Int(w)
        }

        XCTAssertEqual(result, 42)
    }
}
