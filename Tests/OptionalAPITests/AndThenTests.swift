
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
}
