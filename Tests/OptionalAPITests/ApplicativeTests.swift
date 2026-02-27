import XCTest
@testable import OptionalAPI

final class ApplicativeTests: XCTestCase {

    // MARK: - ap extension

    func test_ap_someFunction_someValue_returnsTransformed() {
        let f: ((Int) -> String)? = { "value: \($0)" }
        let value: Int? = 42

        let result: String? = f.ap(value)

        XCTAssertEqual(result, "value: 42")
    }

    func test_ap_someFunction_noneValue_returnsNone() {
        let f: ((Int) -> String)? = { "value: \($0)" }
        let value: Int? = nil

        let result: String? = f.ap(value)

        XCTAssertNil(result)
    }

    func test_ap_noneFunction_someValue_returnsNone() {
        let f: ((Int) -> String)? = nil
        let value: Int? = 42

        let result: String? = f.ap(value)

        XCTAssertNil(result)
    }

    func test_ap_noneFunction_noneValue_returnsNone() {
        let f: ((Int) -> String)? = nil
        let value: Int? = nil

        let result: String? = f.ap(value)

        XCTAssertNil(result)
    }

    // MARK: - ap free function

    func test_ap_freeFunction_someFunction_someValue() {
        let f: ((Int) -> Int)? = { $0 + 1 }
        let value: Int? = 41

        let result: Int? = ap(f, value)

        XCTAssertEqual(result, 42)
    }

    func test_ap_freeFunction_curried() {
        let f: ((Int) -> Int)? = { $0 * 2 }
        let apF: (Int?) -> Int? = ap(f)

        XCTAssertEqual(apF(21), 42)
        XCTAssertNil(apF(nil))
    }

    // MARK: - Async

    func test_asyncAp_someFunction_someValue() async {
        let f: ((Int) -> String)? = { "async: \($0)" }
        let value: Int? = 42

        let result: String? = await f.asyncAp(value)

        XCTAssertEqual(result, "async: 42")
    }
}
