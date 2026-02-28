import Foundation
import Testing
import OptionalAPI

@Suite struct AndThenTests {

    @Test func test_andThenTry_whenSomeCase_transformsThrowsAnError_should_returnOptional() {
        #expect(throws: Never.self) {
            _ = someSomeString.andThenTry(alwaysThrowing)
        }

        #expect(someSomeString.andThenTry(alwaysThrowing) == nil)
    }

    @Test func test_andThenTry_whenSomeCase_transformsDoesNotThrowsAnError_should_returnOptionalWithTransformedValue() {
        #expect(throws: Never.self) {
            _ = someSomeString.andThenTry(alwaysReturningString)
        }

        #expect(
            someSomeString.andThenTry(alwaysReturningString) == "It works fine"
        )

        codableStructAsData
            .andThenTry { data in try JSONDecoder().decode(CodableStruct.self, from: data) }
            .andThen { (_: CodableStruct) in }
    }

    @Test func test_asyncAndThen_whenNone_shouldNotCallTransform_andReturnNone() async {
        let none: Int? = .none

        let result: Int? = await none.asyncAndThen { _ in
            Issue.record("Should not call this closure!")
            return 42
        }

        #expect(result == nil)
    }

    @Test func test_asyncAndThen_whenSome_shouldCallTransform_andReturnExpectedValue() async {
        let some: Int? = 41

        let result: Int? = await some.asyncAndThen { wrapped in
            try? await Task.sleep(nanoseconds: 42)
            return wrapped + 1
        }

        #expect(result == 42)
    }

    @Test func test_tryAsyncAndThenTryOrThrow_whenNone_shouldNotCallTransform_andReturnNone() async throws {
        let none: Int? = .none

        let result: Int? = try await none.tryAsyncAndThenTryOrThrow { _ in
            Issue.record("Should not call this closure!")
            return 42
        }

        #expect(result == nil)
    }

    @Test func test_tryAsyncAndThenTryOrThrow_whenSome_shouldCallTransform_andReturnExpectedValue() async throws {
        let some: Int? = 41

        let result: Int? = try await some.tryAsyncAndThenTryOrThrow { wrapped in
            try await Task.sleep(nanoseconds: 42)
            return wrapped + 1
        }

        #expect(result == 42)
    }

    @Test func test_tryAsyncAndThenTryOrThrow_whenSome_whenTransformThrows_shouldThrow() async {
        let some: Int? = 41

        await #expect(throws: DummyError.self) {
            _ = try await some.tryAsyncAndThenTryOrThrow { _ in
                try await Task.sleep(nanoseconds: 42)
                throw DummyError.boom
            }
        }
    }

    @Test func test_tryAsyncAndThenTry_whenNone_shouldNotCallTransform_andReturnNone() async throws {
        let none: Int? = .none

        let result: Int? = try await none.tryAsyncAndThenTry { _ in
            Issue.record("Should not call this closure!")
            return 42
        }

        #expect(result == nil)
    }

    @Test func test_tryAsyncAndThenTry_whenSome_shouldCallTransform_andReturnExpectedValue() async throws {
        let some: Int? = 41

        let result: Int? = try await some.tryAsyncAndThenTry { wrapped in
            try await Task.sleep(nanoseconds: 42)
            return wrapped + 1
        }

        #expect(result == 42)
    }

    @Test func test_tryAsyncAndThenTry_whenSome_whenTransformThrows_shouldReturnNone() async throws {
        let some: Int? = 41

        let result: Int? = try await some.tryAsyncAndThenTry { _ in
            try await Task.sleep(nanoseconds: 42)
            throw DummyError.boom
        }

        #expect(result == nil)
    }
}
