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
    
    func test_cast_shouldNot_requireTypeParameterWhenItCanBeInferred() {
        let result: String? = anyString.cast()
        
        XCTAssertNotNil(result)
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
    
    func test_cast_shouldProduce_sameResultAsInlinedCast() {
        XCTAssertEqual(
            noneString.andThen({ $0 as? String }),
            noneString.cast(String.self)
        )
        XCTAssertEqual(
            noneString.andThen({ $0 as? Int }),
            noneString.cast(Int.self)
        )
        
        XCTAssertEqual(
            anyString.andThen({ $0 as? String }),
            anyString.cast(String.self)
        )
        XCTAssertEqual(
            anyString.andThen({ $0 as? Int }),
            anyString.cast(Int.self)
        )
        
        XCTAssertEqual(
            anyNoneString.andThen({ $0 as? String }),
            anyNoneString.cast(String.self)
        )
        XCTAssertEqual(
            anyNoneString.andThen({ $0 as? Int }),
            anyNoneString.cast(Int.self)
        )
        
        XCTAssertEqual(
            anyInt.andThen({ $0 as? String }),
            anyInt.cast(String.self)
        )
        XCTAssertEqual(
            anyInt.andThen({ $0 as? Int }),
            anyInt.cast(Int.self)
        )
        
        XCTAssertEqual(
            anyNoneInt.andThen({ $0 as? String }),
            anyNoneInt.cast(String.self)
        )
        XCTAssertEqual(
            anyNoneInt.andThen({ $0 as? Int }),
            anyNoneInt.cast(Int.self)
        )
    }
    
    func test_randomCombinators() {
        XCTAssertEqual(
            anyInt
                .cast(Int.self)
                .andThen({ $0 + 1 }),
            43
        )
        
        XCTAssertEqual(
            anyString
                .cast(String.self)
                .andThen({ $0.uppercased() }),
            "ANY STRING"
        )        
    }
}
