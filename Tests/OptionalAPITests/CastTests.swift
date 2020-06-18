import XCTest
import OptionalAPI


class CastTests: XCTestCase {
    
    func test_cast_should_returnCastedOptional() {
        // Arrange
        var didCast = false
        
        // Act
        let result: String? = anyString.cast(String.self)
        
        // Assert
        result
            .mapNone({ () -> String in
                XCTFail("Should be able to cast!")
                return "fail"
                }())
            .andThen ({ (string: String) -> String in
                didCast = true
                
                return string
            })
        
        XCTAssertTrue(
            didCast,
            "Should cast \(String(describing: anyString)) to String"
        )
        XCTAssertEqual(
            result, "any string"
        )
    }
    
    func test_cast_shouldReturn_NoneForFailedCast() {
        // Arrange && Act
        let result: Int? = anyString.cast(Int.self)
        
        // Assert
        result
            .andThen ({ (number: Int) -> Int in
                XCTFail("Should NOT cast!")
                
                return number
            })
        
        XCTAssertNil(result)
    }
    
    func test_cast_toDifferentType_shouldReturn_NoneForNone() {
        // Arrange && Act
        let result: Int? = anyNoneString.cast(Int.self)
        
        // Assert
        result
            .andThen ({ (number: Int) -> Int in
                XCTFail("Should NOT cast!")
                
                return number
            })
        
        XCTAssertNil(result)
    }
    
    func test_cast_toSameType_shouldReturn_NoneForNone() {
        // Arrange && Act
        let result: String? = anyNoneString.cast(String.self)
        
        // Assert
        result
            .andThen ({ (string: String) -> String in
                XCTFail("Should NOT cast!")
                
                return string
            })
        
        XCTAssertNil(result)
    }
}
