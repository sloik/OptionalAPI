import XCTest
@testable import OptionalAPI

// A simple actor used to verify that async APIs compile and work
// correctly when called from an isolated concurrency context.
private actor Counter {
    var count: Int = 0
    func increment() { count += 1 }
    func value() -> Int { count }
}

final class SendableTests: XCTestCase {

    // MARK: - asyncMap

    func test_asyncMap_acceptsSendableClosure() async {
        let value: Int? = 21
        let result = await value.asyncMap { @Sendable v in v * 2 }
        XCTAssertEqual(result, 42)
    }

    func test_asyncMap_fromActor() async {
        let counter = Counter()
        let value: Int? = 1

        let result = await value.asyncMap { @Sendable v -> Int in
            await counter.increment()
            return v + 1
        }

        XCTAssertEqual(result, 2)
        let count = await counter.value()
        XCTAssertEqual(count, 1)
    }

    func test_asyncMap_none_doesNotCallClosure() async {
        let value: Int? = nil
        var called = false
        let result = await value.asyncMap { @Sendable v -> Int in
            called = true
            return v
        }
        XCTAssertNil(result)
        XCTAssertFalse(called)
    }

    // MARK: - asyncFlatMap

    func test_asyncFlatMap_acceptsSendableClosure() async {
        let value: Int? = 42
        let result = await value.asyncFlatMap { @Sendable v -> Int? in v > 0 ? v : nil }
        XCTAssertEqual(result, 42)
    }

    func test_asyncFlatMap_fromActor() async {
        let counter = Counter()
        let value: Int? = 10

        let result = await value.asyncFlatMap { @Sendable v -> Int? in
            await counter.increment()
            return v * 2
        }

        XCTAssertEqual(result, 20)
        let count = await counter.value()
        XCTAssertEqual(count, 1)
    }

    // MARK: - asyncAndThen

    func test_asyncAndThen_acceptsSendableClosure() async {
        let value: Int? = 10
        let result = await value.asyncAndThen { @Sendable v -> Int? in v + 1 }
        XCTAssertEqual(result, 11)
    }

    func test_asyncAndThen_fromActor() async {
        let counter = Counter()
        let value: String? = "hello"

        let result = await value.asyncAndThen { @Sendable s -> String? in
            await counter.increment()
            return s.uppercased()
        }

        XCTAssertEqual(result, "HELLO")
        let count = await counter.value()
        XCTAssertEqual(count, 1)
    }

    // MARK: - asyncOr

    func test_asyncOr_some_doesNotCallProducer() async {
        let value: Int? = 42
        var called = false
        let result = await value.asyncOr { @Sendable in
            called = true
            return 0
        }
        XCTAssertEqual(result, 42)
        XCTAssertFalse(called)
    }

    func test_asyncOr_none_callsProducer() async {
        let value: Int? = nil
        let result = await value.asyncOr { @Sendable in 99 }
        XCTAssertEqual(result, 99)
    }

    func test_asyncOr_fromActor() async {
        let counter = Counter()
        let value: Int? = nil

        let result = await value.asyncOr { @Sendable in
            await counter.increment()
            return 7
        }

        XCTAssertEqual(result, 7)
        let count = await counter.value()
        XCTAssertEqual(count, 1)
    }

    // MARK: - asyncMapNone / asyncDefaultSome

    func test_asyncMapNone_acceptsSendableClosure() async {
        let value: Int? = nil
        let result = await value.asyncMapNone { @Sendable in 42 }
        XCTAssertEqual(result, 42)
    }

    func test_asyncDefaultSome_acceptsSendableClosure() async {
        let value: Int? = nil
        let result = await value.asyncDefaultSome { @Sendable in 42 }
        XCTAssertEqual(result, 42)
    }

    func test_asyncMapNone_some_doesNotCallProducer() async {
        let value: Int? = 10
        var called = false
        let result = await value.asyncMapNone { @Sendable in
            called = true
            return 99
        }
        XCTAssertEqual(result, 10)
        XCTAssertFalse(called)
    }

    // MARK: - asyncFilter

    func test_asyncFilter_acceptsSendableClosure() async {
        let value: Int? = 42
        let result = await value.asyncFilter { @Sendable v in v > 10 }
        XCTAssertEqual(result, 42)
    }

    func test_asyncFilter_fails_returnsNone() async {
        let value: Int? = 5
        let result = await value.asyncFilter { @Sendable v in v > 10 }
        XCTAssertNil(result)
    }

    func test_asyncFilter_fromActor() async {
        let counter = Counter()
        let value: Int? = 42

        let result = await value.asyncFilter { @Sendable v in
            await counter.increment()
            return v > 0
        }

        XCTAssertEqual(result, 42)
        let count = await counter.value()
        XCTAssertEqual(count, 1)
    }

    // MARK: - asyncFold

    func test_asyncFold_some_callsSomeCase() async {
        let value: Int? = 42
        let result = await value.asyncFold(0) { @Sendable v in v + 1 }
        XCTAssertEqual(result, 43)
    }

    func test_asyncFold_none_returnsNoneCase() async {
        let value: Int? = nil
        let result = await value.asyncFold(99) { @Sendable v in v + 1 }
        XCTAssertEqual(result, 99)
    }

    // MARK: - asyncWhenSome / asyncWhenNone

    func test_asyncWhenSome_noArg_acceptsSendableClosure() async {
        let value: Int? = 42
        var ran = false
        _ = await value.asyncWhenSome { @Sendable in ran = true }
        XCTAssertTrue(ran)
    }

    func test_asyncWhenSome_withArg_acceptsSendableClosure() async {
        let value: Int? = 42
        var captured = 0
        _ = await value.asyncWhenSome { @Sendable v in captured = v }
        XCTAssertEqual(captured, 42)
    }

    func test_asyncWhenNone_acceptsSendableClosure() async {
        let value: Int? = nil
        var ran = false
        _ = await value.asyncWhenNone { @Sendable in ran = true }
        XCTAssertTrue(ran)
    }

    func test_asyncWhenSome_fromActor() async {
        let counter = Counter()
        let value: Int? = 1

        _ = await value.asyncWhenSome { @Sendable _ in
            await counter.increment()
        }

        let count = await counter.value()
        XCTAssertEqual(count, 1)
    }

    // MARK: - asyncRecoverFromEmpty

    func test_asyncRecoverFromEmpty_empty_callsProducer() async {
        let value: [Int]? = []
        let result = await value.asyncRecoverFromEmpty { @Sendable in [42] }
        XCTAssertEqual(result, [42])
    }

    func test_asyncRecoverFromEmpty_nonEmpty_doesNotCallProducer() async {
        let value: [Int]? = [1, 2, 3]
        var called = false
        let result = await value.asyncRecoverFromEmpty { @Sendable in
            called = true
            return [42]
        }
        XCTAssertEqual(result, [1, 2, 3])
        XCTAssertFalse(called)
    }

    // MARK: - asyncOrOptional

    func test_asyncOrOptional_none_callsOther() async {
        let value: Int? = nil
        let result = await value.asyncOrOptional { @Sendable in 42 }
        XCTAssertEqual(result, 42)
    }

    func test_asyncOrOptional_some_doesNotCallOther() async {
        let value: Int? = 10
        var called = false
        let result = await value.asyncOrOptional { @Sendable in
            called = true
            return 99
        }
        XCTAssertEqual(result, 10)
        XCTAssertFalse(called)
    }
}
