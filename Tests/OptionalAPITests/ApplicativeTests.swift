import Testing
@testable import OptionalAPI

@Suite struct ApplicativeTests {

    @Test func test_ap_someFunction_someValue_returnsTransformed() {
        let f: ((Int) -> String)? = { "value: \($0)" }
        let value: Int? = 42

        let result: String? = f.ap(value)

        #expect(result == "value: 42")
    }

    @Test func test_ap_someFunction_noneValue_returnsNone() {
        let f: ((Int) -> String)? = { "value: \($0)" }
        let value: Int? = nil

        let result: String? = f.ap(value)

        #expect(result == nil)
    }

    @Test func test_ap_noneFunction_someValue_returnsNone() {
        let f: ((Int) -> String)? = nil
        let value: Int? = 42

        let result: String? = f.ap(value)

        #expect(result == nil)
    }

    @Test func test_ap_noneFunction_noneValue_returnsNone() {
        let f: ((Int) -> String)? = nil
        let value: Int? = nil

        let result: String? = f.ap(value)

        #expect(result == nil)
    }

    @Test func test_ap_freeFunction_someFunction_someValue() {
        let f: ((Int) -> Int)? = { $0 + 1 }
        let value: Int? = 41

        let result: Int? = ap(f, value)

        #expect(result == 42)
    }

    @Test func test_ap_freeFunction_curried() {
        let f: ((Int) -> Int)? = { $0 * 2 }
        let apF: (Int?) -> Int? = ap(f)

        #expect(apF(21) == 42)
        #expect(apF(nil) == nil)
    }

    @Test func test_asyncAp_someFunction_someValue() async {
        let f: ((Int) -> String)? = { "async: \($0)" }
        let value: Int? = 42

        let result: String? = await f.asyncAp(value)

        #expect(result == "async: 42")
    }
}
