import XCTest
@testable import OptionalAPI

final class ConditionalConstructionTests: XCTestCase {

    // MARK: - someWhen

    func test_someWhen_predicateTrue_returnsSome() {
        let result = someWhen({ $0 > 18 }, 42)

        XCTAssertEqual(result, 42)
    }

    func test_someWhen_predicateFalse_returnsNone() {
        let result = someWhen({ $0 > 18 }, 10)

        XCTAssertNil(result)
    }

    func test_someWhen_curried_predicateTrue() {
        let adults: (Int) -> Int? = someWhen { $0 >= 18 }

        XCTAssertEqual(adults(42), 42)
    }

    func test_someWhen_curried_predicateFalse() {
        let adults: (Int) -> Int? = someWhen { $0 >= 18 }

        XCTAssertNil(adults(10))
    }

    func test_someWhen_withString() {
        let nonEmpty: (String) -> String? = someWhen { !$0.isEmpty }

        XCTAssertEqual(nonEmpty("hello"), "hello")
        XCTAssertNil(nonEmpty(""))
    }

    // MARK: - noneWhen

    func test_noneWhen_predicateTrue_returnsNone() {
        let result = noneWhen({ $0 > 100 }, 200)

        XCTAssertNil(result)
    }

    func test_noneWhen_predicateFalse_returnsSome() {
        let result = noneWhen({ $0 > 100 }, 42)

        XCTAssertEqual(result, 42)
    }

    func test_noneWhen_curried() {
        let notEmpty: (String) -> String? = noneWhen(\.isEmpty)

        XCTAssertEqual(notEmpty("hello"), "hello")
        XCTAssertNil(notEmpty(""))
    }

    // MARK: - composition

    func test_someWhen_composesWithAndThen() {
        let result = someWhen({ $0 > 0 }, 42)
            .andThen { $0 * 2 }

        XCTAssertEqual(result, 84)
    }

    func test_noneWhen_composesWithMapNone() {
        let result = noneWhen({ $0 > 100 }, 200)
            .mapNone(0)

        XCTAssertEqual(result, 0)
    }
}
