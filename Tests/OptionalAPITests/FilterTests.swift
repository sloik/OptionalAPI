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
}

func alwaysTruePredicate<T>(_ value: T) -> Bool { true }
func alwaysFalsePredicate<T>(_ value: T) -> Bool { false }
