import XCTest
import OptionalAPI


class FilterTests: XCTestCase {

    let sutTrue: (Int?) -> Int? = OptionalAPI.filter( alwaysTruePredicate )
    let sutFalse: (Int?) -> Int? = OptionalAPI.filter( alwaysFalsePredicate )

    func test_filteringSomeOptional_withSuccessPredicate_shouldBeSome() {
        XCTAssertNotNil(
            sutTrue( 42 )
        )
    }
    
    func test_filteringNoneOptional_withSuccessPredicate_shouldBeNone() {
        XCTAssertNil(
            sutTrue( .none )
        )
    }
    
    func test_filteringSomeOptional_withFailurePredicate_shouldBeNone() {
        XCTAssertNil(
            sutFalse( 42 )
        )
    }
    
    func test_filteringNoneOptional_withFailurePredicate_shouldBeNone() {
        XCTAssertNil(
            sutFalse( .none )
        )
    }

    func test_api() {
        let arrayWithTwoElements: [Int]? = [42, 69]

        XCTAssertNotNil(
            arrayWithTwoElements
                .filter { array in array.count > 1 }
        )

        XCTAssertNil(
            arrayWithTwoElements
                .filter { array in array.isEmpty }
        )
    }

    func test_asyncFilter_whenSome_shouldReturnSomeForPassingPredicate() async {
        let result = await someInt.asyncFilter { value in
            try? await Task.sleep(nanoseconds: 42)
            return value > 41
        }

        XCTAssertEqual(result, someInt)
    }

    func test_asyncFilter_whenSome_shouldReturnNoneForFailingPredicate() async {
        let result = await someInt.asyncFilter { value in
            try? await Task.sleep(nanoseconds: 42)
            return value > 99
        }

        XCTAssertNil(result)
    }

    func test_asyncFilter_whenNone_shouldNotCallPredicate_andReturnNone() async {
        let didCallPredicate = expectation(description: "predicate was called")
        didCallPredicate.isInverted = true

        let result: Int? = await noneInt.asyncFilter { _ in
            didCallPredicate.fulfill()
            return true
        }

        XCTAssertNil(result)
        await fulfillment(of: [didCallPredicate], timeout: 0.5)
    }
}

func alwaysTruePredicate<T>(_ value: T) -> Bool { true }
func alwaysFalsePredicate<T>(_ value: T) -> Bool { false }
