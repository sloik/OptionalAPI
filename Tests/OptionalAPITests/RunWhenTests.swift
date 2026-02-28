import Testing
import OptionalAPI

@Suite struct RunWhenTests {

    @Test func test_whenSome_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = 42

        await confirmation("Block should have been called!") { confirm in
            sut.whenSome { wrapped in
                #expect(wrapped == 42, "Should not modify value!")
                confirm()
            }
        }
    }

    @Test func test_asyncWhenSome_withArgument_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = 42

        await confirmation("Block should have been called!") { confirm in
            await sut.asyncWhenSome { wrapped in
                #expect(wrapped == 42, "Should not modify value!")
                confirm()
            }
        }
    }

    @Test func test_asyncWhenSome_withArgument_shouldNotCallBlock_whenNone() async {
        let sut: Int? = .none

        await confirmation("Block should not have been called!", expectedCount: 0) { confirm in
            await sut.asyncWhenSome { _ in
                confirm()
            }
        }
    }

    @Test func test_whenSome_withNoArguments_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = 42

        await confirmation("Block should have been called!") { confirm in
            sut.whenSome { confirm() }
        }
    }

    @Test func test_asyncWhenSome_withNoArguments_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = 42

        await confirmation("Block should have been called!") { confirm in
            await sut.asyncWhenSome {
                confirm()
            }
        }
    }

    @Test func test_asyncWhenSome_withNoArguments_shouldNotCallBlock_whenNone() async {
        let sut: Int? = .none

        await confirmation("Block should not have been called!", expectedCount: 0) { confirm in
            await sut.asyncWhenSome {
                confirm()
            }
        }
    }

    @Test func test_whenNone_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = .none

        await confirmation("Block should have been called!") { confirm in
            sut.whenNone { confirm() }
        }
    }

    @Test func test_asyncWhenNone_shouldCallBlock_onlyWhenIsNone() async {
        let sut: Int? = .none

        await confirmation("Block should have been called!") { confirm in
            await sut.asyncWhenNone {
                confirm()
            }
        }
    }

    @Test func test_asyncWhenNone_shouldNotCallBlock_whenSome() async {
        let sut: Int? = 42

        await confirmation("Block should not have been called!", expectedCount: 0) { confirm in
            await sut.asyncWhenNone {
                confirm()
            }
        }
    }

    @Test func test_tryWhenSome_withArgument_shouldCallBlock_onlyWhenIsSome() async throws {
        let sut: Int? = 42

        await confirmation("Block should have been called!") { confirm in
            try? sut.tryWhenSome { wrapped in
                #expect(wrapped == 42, "Should not modify value!")
                confirm()
            }
        }
    }

    @Test func test_tryAsyncWhenSome_withArgument_shouldCallBlock_onlyWhenIsSome() async throws {
        let sut: Int? = 42

        await confirmation("Block should have been called!") { confirm in
            try? await sut.tryAsyncWhenSome { wrapped in
                #expect(wrapped == 42, "Should not modify value!")
                confirm()
            }
        }
    }

    @Test func test_tryAsyncWhenSome_withArgument_shouldNotCallBlock_whenNone() async throws {
        let sut: Int? = .none

        await confirmation("Block should not have been called!", expectedCount: 0) { confirm in
            try? await sut.tryAsyncWhenSome { _ in
                confirm()
            }
        }
    }

    @Test func test_tryAsyncWhenSome_withArgument_shouldThrow_whenBlockThrows() async {
        let sut: Int? = 42

        await #expect(throws: DummyError.self) {
            _ = try await sut.tryAsyncWhenSome { _ in
                try await Task.sleep(nanoseconds: 42)
                throw DummyError.boom
            }
        }
    }
}
