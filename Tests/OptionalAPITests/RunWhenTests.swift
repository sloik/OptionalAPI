import XCTest
import OptionalAPI

class RunWhenTests: XCTestCase {
    
    func test_whenSome_shouldCallBlock_onlyWhenIsSome() {
        // Arrange
        let sut: Int? = 42
        
        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true
        
        // Act
        sut.whenSome { wrapped in
            XCTAssertEqual(wrapped, 42, "Should not modify value!")
            shouldCallBlock.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 2)
    }
    
    func test_whenSome_withNoArguments_shouldCallBlock_onlyWhenIsSome() {
        // Arrange
        let sut: Int? = 42
        
        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true
        
        // Act
        sut.whenSome { shouldCallBlock.fulfill() }
        
        // Assert
        waitForExpectations(timeout: 2)
    }
    
    func test_whenNone_shouldCallBlock_onlyWhenIsSome() {
        // Arrange
        let sut: Int? = .none
        
        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true
        
        // Act
        sut.whenNone { shouldCallBlock.fulfill() }
        
        // Assert
        waitForExpectations(timeout: 2)
    }
}
