import XCTest
@testable import OptionalAPI

final class FlattenTests: XCTestCase {

    // MARK: - flatten extension

    func test_flatten_someSome_returnsSome() {
        let nested: Int?? = .some(.some(42))

        let result: Int? = nested.flatten()

        XCTAssertEqual(result, 42)
    }

    func test_flatten_someNone_returnsNone() {
        let nested: Int?? = .some(nil)

        let result: Int? = nested.flatten()

        XCTAssertNil(result)
    }

    func test_flatten_none_returnsNone() {
        let nested: Int?? = nil

        let result: Int? = nested.flatten()

        XCTAssertNil(result)
    }

    func test_flatten_withStringType() {
        let nested: String?? = .some(.some("hello"))

        let result: String? = nested.flatten()

        XCTAssertEqual(result, "hello")
    }

    // MARK: - flatten free function

    func test_flatten_freeFunction_someSome() {
        let nested: Int?? = .some(.some(42))

        let result: Int? = flatten(nested)

        XCTAssertEqual(result, 42)
    }

    func test_flatten_freeFunction_someNone() {
        let nested: Int?? = .some(nil)

        let result: Int? = flatten(nested)

        XCTAssertNil(result)
    }

    func test_flatten_freeFunction_none() {
        let nested: Int?? = nil

        let result: Int? = flatten(nested)

        XCTAssertNil(result)
    }
}
