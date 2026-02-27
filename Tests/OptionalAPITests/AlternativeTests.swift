import XCTest
@testable import OptionalAPI

final class AlternativeTests: XCTestCase {

    // MARK: - orOptional

    func test_orOptional_someFirst_returnsFirst() {
        let first: Int? = 10
        let second: Int? = 42

        let result = first.orOptional(second)

        XCTAssertEqual(result, 10)
    }

    func test_orOptional_noneFirst_returnsSecond() {
        let first: Int? = nil
        let second: Int? = 42

        let result = first.orOptional(second)

        XCTAssertEqual(result, 42)
    }

    func test_orOptional_noneBoth_returnsNone() {
        let first: Int? = nil
        let second: Int? = nil

        let result = first.orOptional(second)

        XCTAssertNil(result)
    }

    func test_orOptional_lazyEvaluation() {
        var evaluated = false
        let first: Int? = 42

        _ = first.orOptional({
            evaluated = true
            return 99
        }())

        XCTAssertFalse(evaluated)
    }

    // MARK: - asyncOrOptional

    func test_asyncOrOptional_noneFirst_returnsSecond() async {
        let first: Int? = nil

        let result = await first.asyncOrOptional {
            return 42
        }

        XCTAssertEqual(result, 42)
    }

    // MARK: - coalesce

    func test_coalesce_variadic_returnsFirstSome() {
        let a: Int? = nil
        let b: Int? = nil
        let c: Int? = 42
        let d: Int? = 99

        let result = coalesce(a, b, c, d)

        XCTAssertEqual(result, 42)
    }

    func test_coalesce_variadic_allNone_returnsNone() {
        let a: Int? = nil
        let b: Int? = nil
        let c: Int? = nil

        let result = coalesce(a, b, c)

        XCTAssertNil(result)
    }

    func test_coalesce_array_returnsFirstSome() {
        let values: [Int?] = [nil, nil, 42, 99]

        let result = coalesce(values)

        XCTAssertEqual(result, 42)
    }

    func test_coalesce_array_allNone_returnsNone() {
        let values: [Int?] = [nil, nil, nil]

        let result = coalesce(values)

        XCTAssertNil(result)
    }

    func test_coalesce_singleSome_returnsThatValue() {
        let result = coalesce(42 as Int?)
        XCTAssertEqual(result, 42)
    }

    func test_coalesce_emptyArray_returnsNone() {
        let values: [Int?] = []

        let result = coalesce(values)

        XCTAssertNil(result)
    }
}
