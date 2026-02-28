import Testing
import OptionalAPI

@Suite struct TryAsyncMapsTests {

    // MARK: Map

    @Test func test_tryAsyncMap_whenNone_shouldNotCallTransform_andReturn_none() async throws {
        let none: Int? = .none

        let result: Void? = try await none.tryAsyncMap { _ in Issue.record("Should not call this closure!") }

        #expect(result == nil)
    }

    @Test func test_tryAsyncMap_whenSome_shouldCallTransform_andReturn_expectedValue() async throws {
        let some: Int? = 42

        let result: Int? = try await some.tryAsyncMap { wrapped in
            try! await Task.sleep(nanoseconds: 42)
            return wrapped * 2
        }

        #expect(result == 84)
    }

    @Test func test_tryAsyncMap_whenSome_whenTransformThrows_shouldThrow() async throws {
        let some: Int? = 42

        enum E: Error { case e }

        await #expect(throws: E.self) {
            try await some.tryAsyncMap { wrapped in
                try! await Task.sleep(nanoseconds: 42)
                throw E.e
            }
        }
    }

    // MARK: Flat Map

    @Test func test_tryAsyncFlatMap_whenNone_shouldNotCallTransform_andReturn_none() async throws {
        let none: Int? = .none

        let result: Void? = try await none.tryAsyncFlatMap { _ in Issue.record("Should not call this closure!") }

        #expect(result == nil)
    }

    @Test func test_tryAsyncFlatMap_whenSome_shouldCallTransform_andReturn_expectedValue() async throws {
        let some: Int? = 42

        let result: Int? = try await some.tryAsyncFlatMap { wrapped in
            try! await Task.sleep(nanoseconds: 42)
            return wrapped * 2
        }

        #expect(result == 84)
    }

    @Test func test_tryAsyncFlatMap_whenSome_whenTransformReturns_optionalValue_shouldReturnExpectedResult() async throws {
        let some: String? = "42"

        let result: Int? = try await some.tryAsyncFlatMap { (w: String) -> Int? in
            try! await Task.sleep(nanoseconds: 42)
            return Int(w)
        }

        #expect(result == 42)
    }

    @Test func test_tryAsyncFlatMap_longerPipeline() async throws {
        let some: Int? = 42

        let result: Int? = try await some
            .tryAsyncFlatMap {
                try await Task.sleep(nanoseconds: 42)
                return $0 + 1
            }
            .flatMap { fromAsync in
                fromAsync * 10
            }

        #expect(result == 430)
    }
}
