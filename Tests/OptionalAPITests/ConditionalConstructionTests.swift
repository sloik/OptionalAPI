import Testing
@testable import OptionalAPI

@Suite struct ConditionalConstructionTests {

    // MARK: - someWhen

    @Test func test_someWhen_predicateTrue_returnsSome() {
        let result = someWhen({ $0 > 18 }, 42)

        #expect(result == 42)
    }

    @Test func test_someWhen_predicateFalse_returnsNone() {
        let result = someWhen({ $0 > 18 }, 10)

        #expect(result == nil)
    }

    @Test func test_someWhen_curried_predicateTrue() {
        let adults: (Int) -> Int? = someWhen { $0 >= 18 }

        #expect(adults(42) == 42)
    }

    @Test func test_someWhen_curried_predicateFalse() {
        let adults: (Int) -> Int? = someWhen { $0 >= 18 }

        #expect(adults(10) == nil)
    }

    @Test func test_someWhen_withString() {
        let nonEmpty: (String) -> String? = someWhen { !$0.isEmpty }

        #expect(nonEmpty("hello") == "hello")
        #expect(nonEmpty("") == nil)
    }

    // MARK: - noneWhen

    @Test func test_noneWhen_predicateTrue_returnsNone() {
        let result = noneWhen({ $0 > 100 }, 200)

        #expect(result == nil)
    }

    @Test func test_noneWhen_predicateFalse_returnsSome() {
        let result = noneWhen({ $0 > 100 }, 42)

        #expect(result == 42)
    }

    @Test func test_noneWhen_curried() {
        let notEmpty: (String) -> String? = noneWhen(\.isEmpty)

        #expect(notEmpty("hello") == "hello")
        #expect(notEmpty("") == nil)
    }

    // MARK: - composition

    @Test func test_someWhen_composesWithAndThen() {
        let result = someWhen({ $0 > 0 }, 42)
            .andThen { $0 * 2 }

        #expect(result == 84)
    }

    @Test func test_noneWhen_composesWithMapNone() {
        let result = noneWhen({ $0 > 100 }, 200)
            .mapNone(0)

        #expect(result == 0)
    }
}
