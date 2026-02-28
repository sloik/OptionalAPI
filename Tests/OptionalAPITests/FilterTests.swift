import Testing
import OptionalAPI

@Suite struct FilterTests {

    let sutTrue: (Int?) -> Int? = OptionalAPI.filter(alwaysTruePredicate)
    let sutFalse: (Int?) -> Int? = OptionalAPI.filter(alwaysFalsePredicate)

    @Test func test_filteringSomeOptional_withSuccessPredicate_shouldBeSome() {
        #expect(sutTrue(42) != nil)
    }

    @Test func test_filteringNoneOptional_withSuccessPredicate_shouldBeNone() {
        #expect(sutTrue(.none) == nil)
    }

    @Test func test_filteringSomeOptional_withFailurePredicate_shouldBeNone() {
        #expect(sutFalse(42) == nil)
    }

    @Test func test_filteringNoneOptional_withFailurePredicate_shouldBeNone() {
        #expect(sutFalse(.none) == nil)
    }

    @Test func test_api() {
        let arrayWithTwoElements: [Int]? = [42, 69]

        #expect(
            arrayWithTwoElements
                .filter { array in array.count > 1 } != nil
        )

        #expect(
            arrayWithTwoElements
                .filter { array in array.isEmpty } == nil
        )
    }

    @Test func test_asyncFilter_whenSome_shouldReturnSomeForPassingPredicate() async {
        let result = await someInt.asyncFilter { value in
            try? await Task.sleep(nanoseconds: 42)
            return value > 41
        }

        #expect(result == someInt)
    }

    @Test func test_asyncFilter_whenSome_shouldReturnNoneForFailingPredicate() async {
        let result = await someInt.asyncFilter { value in
            try? await Task.sleep(nanoseconds: 42)
            return value > 99
        }

        #expect(result == nil)
    }

    @Test func test_asyncFilter_whenNone_shouldNotCallPredicate_andReturnNone() async {
        let result: Int? = await confirmation("predicate was called", expectedCount: 0) { confirm in
            await noneInt.asyncFilter { _ in
                confirm()
                return true
            }
        }

        #expect(result == nil)
    }
}

func alwaysTruePredicate<T>(_ value: T) -> Bool { true }
func alwaysFalsePredicate<T>(_ value: T) -> Bool { false }
