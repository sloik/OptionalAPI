
import Foundation

import XCTest
import OptionalAPI

final class AndThenTests: XCTestCase {
    
    func test_andThenTry_whenSomeCase_transformsThrowsAnError_should_returnOptional() {
        XCTAssertNoThrow(
            someSomeString.andThenTry( alwaysThrowing ),
            "Error in throwing function should be handled by the operator!"
        )
        
        XCTAssertNil(
            someSomeString.andThenTry( alwaysThrowing ),
            "Error in throwing function should make operator return `none`!"
        )
    }
    
    func test_andThenTry_whenSomeCase_transformsDoesNotThrowsAnError_should_returnOptionalWithTransformedValue() {
        XCTAssertNoThrow(
            someSomeString.andThenTry( alwaysReturningString ),
            "Error in throwing function should be handled by the operator!"
        )
        
        XCTAssertEqual(
            someSomeString.andThenTry( alwaysReturningString ),
            "It works fine",
            "When throwing transform does not throw returned value should be returned!"
        )
        
        codableStructAsData
            .andThenTry{ data in try JSONDecoder().decode(CodableStruct.self, from: data) }
            .andThen { (instance: CodableStruct) in
                
            }
    }

    func test_asyncAndThen_whenNone_shouldNotCallTransform_andReturnNone() async {
        let none: Int? = .none

        let result: Int? = await none.asyncAndThen { _ in
            XCTFail("Should not call this closure!")
            return 42
        }

        XCTAssertNil(result)
    }

    func test_asyncAndThen_whenSome_shouldCallTransform_andReturnExpectedValue() async {
        let some: Int? = 41

        let result: Int? = await some.asyncAndThen { wrapped in
            try? await Task.sleep(nanoseconds: 42)
            return wrapped + 1
        }

        XCTAssertEqual(result, 42)
    }
}
