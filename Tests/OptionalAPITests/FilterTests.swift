import XCTest
import OptionalAPI


class FilterTests: XCTestCase {

    func test_filteringSomeOptional_withSuccessPredicate_shouldBeSome() {
        XCTAssertNotNil(
            Int?.some(42).filter(alwaysTruePredicate)
        )
    }
    
    func test_filteringNoneOptional_withSuccessPredicate_shouldBeNone() {
        XCTAssertNil(
            Int?.none.filter(alwaysTruePredicate)
        )
    }
    
    func test_filteringSomeOptional_withFailurePredicate_shouldBeNone() {
        XCTAssertNil(
            Int?.some(42).filter(alwaysFalsePredicate)
        )
    }
    
    func test_filteringNoneOptional_withFailurePredicate_shouldBeNone() {
        XCTAssertNil(
            Int?.none.filter(alwaysFalsePredicate)
        )
    }
}

func alwaysTruePredicate<T>(_ value: T) -> Bool { true }
func alwaysFalsePredicate<T>(_ value: T) -> Bool { false }
