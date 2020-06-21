import Foundation

import XCTest
import OptionalAPI

class JustTests: XCTestCase {

    func test_shouldReturn_valeWrappedInOptional() {
        // Arragne
        let value = 42

        // Act
        let result: Int? = just(value)

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, value)
    }

    func test_shouldNot_wrapOptionalInAnotherLayer() {
        // Arragne
        let value: Int?? = .some(42)

        // Act
        let result: Int? = just(value)
    }
}
