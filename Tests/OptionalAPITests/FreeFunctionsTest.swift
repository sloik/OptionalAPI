import XCTest
import OptionalAPI

class FreeFunctionsTests: XCTestCase {

    func test_isNone() throws {
        // Act & Assert
        XCTAssertEqual(isNone(noneInt),
                       noneInt == nil)

        XCTAssertEqual(isNone(someInt),
                       someInt == nil)

        XCTAssertEqual(isNone(noneString),
                       noneString == nil)

        XCTAssertEqual(isNone(emptySomeString),
                       emptySomeString == nil)

        XCTAssertEqual(isNone(someSomeString),
                       someSomeString == nil)

        XCTAssertEqual(isNone(noneIntArray),
                       noneIntArray == nil)

        XCTAssertEqual(isNone(emptyIntArray),
                       emptyIntArray == nil)

        XCTAssertEqual(isNone(someIntArray),
                       someIntArray == nil)
    }


    func test_isSome() throws {
        // Act & Assert
        XCTAssertEqual(isSome(noneInt),
                       noneInt != nil)

        XCTAssertEqual(isSome(someInt),
                       someInt != nil)

        XCTAssertEqual(isSome(noneString),
                       noneString != nil)

        XCTAssertEqual(isSome(emptySomeString),
                       emptySomeString != nil)

        XCTAssertEqual(isSome(someSomeString),
                       someSomeString != nil)

        XCTAssertEqual(isSome(noneIntArray),
                       noneIntArray != nil)

        XCTAssertEqual(isSome(emptyIntArray),
                       emptyIntArray != nil)

        XCTAssertEqual(isSome(someIntArray),
                       someIntArray != nil)
    }


    func test_isNotNone() throws {
        // Act & Assert
        XCTAssertFalse(isNotNone(noneInt))
        XCTAssertEqual(isNotNone(noneInt),
                       noneInt != nil)

        XCTAssertTrue (isNotNone(someInt))
        XCTAssertEqual(isNotNone(someInt),
                       someInt != nil)
    }


    // MARK: - or

    func test_or_shouldNotChangeSome() {
        XCTAssertEqual(
            or(someInt, 69),
            someInt
        )

        XCTAssertEqual(
            or(someInt, { print(#function) ; return 69 }),
            someInt
        )
    }


    func test_or_shouldGiveDefaultValue() {
        XCTAssertEqual(
            noneInt.or(69),
            69
        )

        XCTAssertEqual(
            or(noneInt, { print(#function) ; return 69 }),
            69
        )
    }


    // MARK: - andThen
    func test_andThen_should_operateOnWrappedValue() {
        // Arrange
        let didCallTransform = expectation(description: "transform was called")

        // Act
        andThen(
            someInt,
            { _ in didCallTransform.fulfill() }
        )

        // Assert
        waitForExpectations(timeout: 0.5)
    }

}
