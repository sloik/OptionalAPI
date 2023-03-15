
import Foundation

import XCTest
import OptionalAPI

final class TryAsyncMapsTests: XCTestCase {

    // MARK: Map

    func test_tryAsyncMap_whenNone_shouldNotCallTransform_andReturn_none() async throws {
        let none: Int? = .none

        let result: Void? = try await none.tryAsyncMap { _ in XCTFail( "Should not call this closure!" ) }

        XCTAssertNil( result )
    }

    func test_tryAsyncMap_whenSome_shouldCallTransform_andReturn_expectedValue() async throws {
        let some: Int? = 42

        let result: Int? = try await some.tryAsyncMap { wrapped in
            try! await Task.sleep(nanoseconds: 42)
            return wrapped * 2
        }

        XCTAssertEqual(result, 84)
    }

    func test_tryAsyncMap_whenSome_whenTransformThrows_shouldThrow() async throws {

        let some: Int? = 42

        enum E: Error { case e }

        do {
            try await some.tryAsyncMap { wrapped in
                try! await Task.sleep(nanoseconds: 42)
                throw E.e
            }

            XCTFail("Should not reach this point!")
        } catch {
            XCTAssert(error is E)
        }
    }


    // MARK: Flat Map

    func test_tryAsyncFlatMap_whenNone_shouldNotCallTransform_andReturn_none() async throws {
        let none: Int? = .none

        let result: Void? = try await none.tryAsyncFlatMap { _ in XCTFail( "Should not call this closure!" ) }

        XCTAssertNil( result )
    }

    func test_tryAsyncFlatMap_whenSome_shouldCallTransform_andReturn_expectedValue() async throws {
        let some: Int? = 42

        let result: Int? = try await some.tryAsyncFlatMap { wrapped in
            try! await Task.sleep(nanoseconds: 42)
            return wrapped * 2
        }

        XCTAssertEqual(result, 84)
    }

    func test_tryAsyncFlatMap_whenSome_whenTransformReturns_optionalValue_shouldReturnExpectedResult() async throws {
        let some: String? = "42"

        let result: Int? = try await some.tryAsyncFlatMap { (w: String) -> Int? in
            try! await Task.sleep(nanoseconds: 42)
            return Int(w)
        }

        XCTAssertEqual(result, 42)
    }

    func test_tryAsyncFlatMap_longerPipeline() async throws {
        let some: Int? = 42

        let result: Int? = try await some
            .tryAsyncFlatMap {
                try await Task.sleep(nanoseconds: 42)
                return $0 + 1
            }
            .flatMap { fromAsync in
                fromAsync * 10
            }

        XCTAssertEqual(result, 430)
    }
}
