import Testing
import OptionalAPI

// A simple actor used to verify that async APIs compile and work
// correctly when called from an isolated concurrency context.
private actor Counter {
    var count: Int = 0
    func increment() { count += 1 }
    func value() -> Int { count }
}

@Suite struct SendableTests {

    // MARK: - asyncMap

    @Test func test_asyncMap_acceptsSendableClosure() async {
        let value: Int? = 21
        let result = await value.asyncMap { @Sendable v in v * 2 }
        #expect(result == 42)
    }

    @Test func test_asyncMap_fromActor() async {
        let counter = Counter()
        let value: Int? = 1

        let result = await value.asyncMap { @Sendable v -> Int in
            await counter.increment()
            return v + 1
        }

        #expect(result == 2)
        let count = await counter.value()
        #expect(count == 1)
    }

    @Test func test_asyncMap_none_doesNotCallClosure() async {
        let value: Int? = nil

        await confirmation("Closure should not be called", expectedCount: 0) { confirm in
            let result = await value.asyncMap { @Sendable v -> Int in
                confirm()
                return v
            }
            #expect(result == nil)
        }
    }

    // MARK: - asyncFlatMap

    @Test func test_asyncFlatMap_acceptsSendableClosure() async {
        let value: Int? = 42
        let result = await value.asyncFlatMap { @Sendable v -> Int? in v > 0 ? v : nil }
        #expect(result == 42)
    }

    @Test func test_asyncFlatMap_fromActor() async {
        let counter = Counter()
        let value: Int? = 10

        let result = await value.asyncFlatMap { @Sendable v -> Int? in
            await counter.increment()
            return v * 2
        }

        #expect(result == 20)
        let count = await counter.value()
        #expect(count == 1)
    }

    // MARK: - asyncAndThen

    @Test func test_asyncAndThen_acceptsSendableClosure() async {
        let value: Int? = 10
        let result = await value.asyncAndThen { @Sendable v -> Int? in v + 1 }
        #expect(result == 11)
    }

    @Test func test_asyncAndThen_fromActor() async {
        let counter = Counter()
        let value: String? = "hello"

        let result = await value.asyncAndThen { @Sendable s -> String? in
            await counter.increment()
            return s.uppercased()
        }

        #expect(result == "HELLO")
        let count = await counter.value()
        #expect(count == 1)
    }

    // MARK: - asyncOr

    @Test func test_asyncOr_some_doesNotCallProducer() async {
        let value: Int? = 42

        await confirmation("Producer should not be called", expectedCount: 0) { confirm in
            let result = await value.asyncOr { @Sendable in
                confirm()
                return 0
            }
            #expect(result == 42)
        }
    }

    @Test func test_asyncOr_none_callsProducer() async {
        let value: Int? = nil
        let result = await value.asyncOr { @Sendable in 99 }
        #expect(result == 99)
    }

    @Test func test_asyncOr_fromActor() async {
        let counter = Counter()
        let value: Int? = nil

        let result = await value.asyncOr { @Sendable in
            await counter.increment()
            return 7
        }

        #expect(result == 7)
        let count = await counter.value()
        #expect(count == 1)
    }

    // MARK: - asyncMapNone / asyncDefaultSome

    @Test func test_asyncMapNone_acceptsSendableClosure() async {
        let value: Int? = nil
        let result = await value.asyncMapNone { @Sendable in 42 }
        #expect(result == 42)
    }

    @Test func test_asyncDefaultSome_acceptsSendableClosure() async {
        let value: Int? = nil
        let result = await value.asyncDefaultSome { @Sendable in 42 }
        #expect(result == 42)
    }

    @Test func test_asyncMapNone_some_doesNotCallProducer() async {
        let value: Int? = 10

        await confirmation("Producer should not be called", expectedCount: 0) { confirm in
            let result = await value.asyncMapNone { @Sendable in
                confirm()
                return 99
            }
            #expect(result == 10)
        }
    }

    // MARK: - asyncFilter

    @Test func test_asyncFilter_acceptsSendableClosure() async {
        let value: Int? = 42
        let result = await value.asyncFilter { @Sendable v in v > 10 }
        #expect(result == 42)
    }

    @Test func test_asyncFilter_fails_returnsNone() async {
        let value: Int? = 5
        let result = await value.asyncFilter { @Sendable v in v > 10 }
        #expect(result == nil)
    }

    @Test func test_asyncFilter_fromActor() async {
        let counter = Counter()
        let value: Int? = 42

        let result = await value.asyncFilter { @Sendable v in
            await counter.increment()
            return v > 0
        }

        #expect(result == 42)
        let count = await counter.value()
        #expect(count == 1)
    }

    // MARK: - asyncFold

    @Test func test_asyncFold_some_callsSomeCase() async {
        let value: Int? = 42
        let result = await value.asyncFold(0) { @Sendable v in v + 1 }
        #expect(result == 43)
    }

    @Test func test_asyncFold_none_returnsNoneCase() async {
        let value: Int? = nil
        let result = await value.asyncFold(99) { @Sendable v in v + 1 }
        #expect(result == 99)
    }

    // MARK: - asyncWhenSome / asyncWhenNone

    @Test func test_asyncWhenSome_noArg_acceptsSendableClosure() async {
        let value: Int? = 42

        await confirmation("Block should be called") { confirm in
            _ = await value.asyncWhenSome { @Sendable in confirm() }
        }
    }

    @Test func test_asyncWhenSome_withArg_acceptsSendableClosure() async {
        let counter = Counter()
        let value: Int? = 42

        _ = await value.asyncWhenSome { @Sendable v in await counter.increment() }

        let count = await counter.value()
        #expect(count == 1)
    }

    @Test func test_asyncWhenNone_acceptsSendableClosure() async {
        let value: Int? = nil

        await confirmation("Block should be called") { confirm in
            _ = await value.asyncWhenNone { @Sendable in confirm() }
        }
    }

    @Test func test_asyncWhenSome_fromActor() async {
        let counter = Counter()
        let value: Int? = 1

        _ = await value.asyncWhenSome { @Sendable _ in
            await counter.increment()
        }

        let count = await counter.value()
        #expect(count == 1)
    }

    // MARK: - asyncRecoverFromEmpty

    @Test func test_asyncRecoverFromEmpty_empty_callsProducer() async {
        let value: [Int]? = []
        let result = await value.asyncRecoverFromEmpty { @Sendable in [42] }
        #expect(result == [42])
    }

    @Test func test_asyncRecoverFromEmpty_nonEmpty_doesNotCallProducer() async {
        let value: [Int]? = [1, 2, 3]

        await confirmation("Producer should not be called", expectedCount: 0) { confirm in
            let result = await value.asyncRecoverFromEmpty { @Sendable in
                confirm()
                return [42]
            }
            #expect(result == [1, 2, 3])
        }
    }

    // MARK: - asyncOrOptional

    @Test func test_asyncOrOptional_none_callsOther() async {
        let value: Int? = nil
        let result = await value.asyncOrOptional { @Sendable in 42 }
        #expect(result == 42)
    }

    @Test func test_asyncOrOptional_some_doesNotCallOther() async {
        let value: Int? = 10

        await confirmation("Producer should not be called", expectedCount: 0) { confirm in
            let result = await value.asyncOrOptional { @Sendable in
                confirm()
                return 99
            }
            #expect(result == 10)
        }
    }
}
