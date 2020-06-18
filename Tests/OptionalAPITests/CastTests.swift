import XCTest
import OptionalAPI


class CastTests: XCTestCase {

    func test_cast_should_returnCastedOptional() {
        // Arrange
        var didCast = false
        
        // Act
        anyString
            .cast(String.self)
            .andThen ({ _ in
                didCast = true
            })
        
        // Assert
        XCTAssertTrue(
            didCast,
            "Should cast \(String(describing: anyString)) to String"
        )
    }
    
    func test_cast_should_returnNone_whenCantCast() {
        // Arrange
        var didNotCast = false
        
        // Act
        anyInt
            .cast(String.self)
            .mapNone({
                didNotCast = true
                return "default"
                }())
        
        // Assert
        XCTAssertTrue(
            didNotCast,
            "Should Not cast \(String(describing: anyInt)) to String"
        )
    }
    
    func test_cast_shouldNot_castNoneCases() {
        // Arrange
        let didCast = expectation(description: "should not cast")
        didCast.isInverted = true
        
        defer { waitForExpectations(timeout: 0.005) }
        
        // Act
        anyString
            .cast(String.self)
            
            // Assert
            .andThen ({ (castedString) in
                XCTAssertEqual(castedString, anyString! as! String)
                didCast.fulfill()
            })
    }
}
