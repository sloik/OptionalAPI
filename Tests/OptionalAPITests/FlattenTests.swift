import Testing
@testable import OptionalAPI

@Suite struct FlattenTests {

    // MARK: - flatten extension

    @Test func test_flatten_someSome_returnsSome() {
        let nested: Int?? = .some(.some(42))

        let result: Int? = nested.flatten()

        #expect(result == 42)
    }

    @Test func test_flatten_someNone_returnsNone() {
        let nested: Int?? = .some(nil)

        let result: Int? = nested.flatten()

        #expect(result == nil)
    }

    @Test func test_flatten_none_returnsNone() {
        let nested: Int?? = nil

        let result: Int? = nested.flatten()

        #expect(result == nil)
    }

    @Test func test_flatten_withStringType() {
        let nested: String?? = .some(.some("hello"))

        let result: String? = nested.flatten()

        #expect(result == "hello")
    }

    // MARK: - flatten free function

    @Test func test_flatten_freeFunction_someSome() {
        let nested: Int?? = .some(.some(42))

        let result: Int? = flatten(nested)

        #expect(result == 42)
    }

    @Test func test_flatten_freeFunction_someNone() {
        let nested: Int?? = .some(nil)

        let result: Int? = flatten(nested)

        #expect(result == nil)
    }

    @Test func test_flatten_freeFunction_none() {
        let nested: Int?? = nil

        let result: Int? = flatten(nested)

        #expect(result == nil)
    }
}
