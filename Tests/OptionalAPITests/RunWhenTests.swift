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

    func test_asyncWhenSome_withArgument_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = 42

        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true

        await sut.asyncWhenSome { wrapped in
            XCTAssertEqual(wrapped, 42, "Should not modify value!")
            shouldCallBlock.fulfill()
        }

        await fulfillment(of: [shouldCallBlock], timeout: 2)
    }

    func test_asyncWhenSome_withArgument_shouldNotCallBlock_whenNone() async {
        let sut: Int? = .none

        let shouldNotCallBlock = expectation(description: "Block should not have been called!")
        shouldNotCallBlock.isInverted = true

        await sut.asyncWhenSome { _ in
            shouldNotCallBlock.fulfill()
        }

        await fulfillment(of: [shouldNotCallBlock], timeout: 0.5)
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

    func test_asyncWhenSome_withNoArguments_shouldCallBlock_onlyWhenIsSome() async {
        let sut: Int? = 42

        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true

        await sut.asyncWhenSome {
            shouldCallBlock.fulfill()
        }

        await fulfillment(of: [shouldCallBlock], timeout: 2)
    }

    func test_asyncWhenSome_withNoArguments_shouldNotCallBlock_whenNone() async {
        let sut: Int? = .none

        let shouldNotCallBlock = expectation(description: "Block should not have been called!")
        shouldNotCallBlock.isInverted = true

        await sut.asyncWhenSome {
            shouldNotCallBlock.fulfill()
        }

        await fulfillment(of: [shouldNotCallBlock], timeout: 0.5)
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

    func test_tryWhenSome_withArgument_shouldCallBlock_onlyWhenIsSome() throws {
        // Arrange
        let sut: Int? = 42
        
        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true
        
        // Act
        try sut.tryWhenSome { wrapped in
            XCTAssertEqual(wrapped, 42, "Should not modify value!")
            shouldCallBlock.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 2)
    }

    func test_tryAsyncWhenSome_withArgument_shouldCallBlock_onlyWhenIsSome() async throws {
        let sut: Int? = 42

        let shouldCallBlock = expectation(description: "Block should have been called!")
        shouldCallBlock.assertForOverFulfill = true

        try await sut.tryAsyncWhenSome { wrapped in
            XCTAssertEqual(wrapped, 42, "Should not modify value!")
            shouldCallBlock.fulfill()
        }

        await fulfillment(of: [shouldCallBlock], timeout: 2)
    }

    func test_tryAsyncWhenSome_withArgument_shouldNotCallBlock_whenNone() async throws {
        let sut: Int? = .none

        let shouldNotCallBlock = expectation(description: "Block should not have been called!")
        shouldNotCallBlock.isInverted = true

        try await sut.tryAsyncWhenSome { _ in
            shouldNotCallBlock.fulfill()
        }

        await fulfillment(of: [shouldNotCallBlock], timeout: 0.5)
    }

    func test_tryAsyncWhenSome_withArgument_shouldThrow_whenBlockThrows() async {
        let sut: Int? = 42

        do {
            _ = try await sut.tryAsyncWhenSome { _ in
                try await Task.sleep(nanoseconds: 42)
                throw DummyError.boom
            }

            XCTFail("Should not reach this point!")
        } catch {
            XCTAssert(error is DummyError)
        }
    }
}
