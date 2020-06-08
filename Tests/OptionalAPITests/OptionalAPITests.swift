import XCTest
@testable import OptionalAPI

// Systems Under Test
let noneString     : String? = .none

let emptySomeString: String? = ""
let someSomeString : String? = "some string"

let noneIntArray : [Int]? = .none
let emptyIntArray: [Int]? = []
let someIntArray : [Int]? = [11, 22, 33]

let noneInt: Int? = .none
let someInt: Int? = .some(42)

final class OptionalAPITests: XCTestCase {

    func test_isNone_property() throws {
        // Act & Assert
        XCTAssertEqual(noneInt.isNone,
                       noneInt == nil)
        
        XCTAssertEqual(someInt.isNone,
                       someInt == nil)
        
        XCTAssertEqual(noneString.isNone,
                       noneString == nil)
        
        XCTAssertEqual(emptySomeString.isNone,
                       emptySomeString == nil)
        
        XCTAssertEqual(someSomeString.isNone,
                       someSomeString == nil)
        
        XCTAssertEqual(noneIntArray.isNone,
                       noneIntArray == nil)
        
        XCTAssertEqual(emptyIntArray.isNone,
                       emptyIntArray == nil)
        
        XCTAssertEqual(someIntArray.isNone,
                       someIntArray == nil)
    }
    
    func test_isSome_property() throws {
        // Act & Assert
        XCTAssertEqual(noneInt.isSome,
                       noneInt != nil)
        
        XCTAssertEqual(someInt.isSome,
                       someInt != nil)
        
        XCTAssertEqual(noneString.isSome,
                       noneString != nil)
        
        XCTAssertEqual(emptySomeString.isSome,
                       emptySomeString != nil)
        
        XCTAssertEqual(someSomeString.isSome,
                       someSomeString != nil)
        
        XCTAssertEqual(noneIntArray.isSome,
                       noneIntArray != nil)
        
        XCTAssertEqual(emptyIntArray.isSome,
                       emptyIntArray != nil)
        
        XCTAssertEqual(someIntArray.isSome,
                       someIntArray != nil)
    }
    
    func test_isNotNone_property() throws {
        // Act & Assert
        XCTAssertEqual(noneInt.isNotNone,
                       noneInt != nil)
        
        XCTAssertEqual(someInt.isNotNone,
                       someInt != nil)
    }
    
    func test_isNotSome_property() throws {
        // Act & Assert
        XCTAssertEqual(noneInt.isNotSome,
                       noneInt == nil)
        
        XCTAssertEqual(someInt.isNotSome,
                       someInt == nil)
    }
    
    // MARK: - or
    
    func test_or_shouldNotChangeSome() {
        XCTAssertEqual(
            someInt.or(69),
            someInt
        )
    }
    
    func test_or_shouldGiveDefaultValue() {
        XCTAssertEqual(
            noneInt.or(69),
            69
        )
    }
    
    // MARK: - andThen
    func test_andThen_should_operateOnWrappedValue() {
        // Arrange
        let didCallTransform = expectation(description: "transform was called")
        
        // Act
        someInt
            .andThen({ _ in didCallTransform.fulfill() })
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_andThen_should_callEachAndThenBlockForSomeCases() {
        // Arrange
        let didCallTransform = expectation(description: "transform was called")
        didCallTransform.expectedFulfillmentCount = 3
        
        // Act
        someInt
            .andThen({ (wrapped: Int) -> Int in
                didCallTransform.fulfill()
                return wrapped
            })
            .andThen({ (wrapped: Int) -> Int in
                didCallTransform.fulfill()
                return wrapped
            })
            .andThen({ (wrapped: Int) -> Int in
                didCallTransform.fulfill()
                return wrapped
            })
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_andThen_should_passInTheWrappedValue() {
        // Arrange
        var accumulator: [Int] = []
        
        // Act
        someInt
            .andThen({ wrapped in accumulator.append(wrapped) })
        
        // Assert
        XCTAssertEqual(accumulator, [42])
    }
    
    func test_andThen_should_returnedTransformedValue() {
        // Act
        let result = someInt
            .andThen({ wrapped in wrapped + 1 })
        
        // Assert
        XCTAssertEqual(result, .some(42 + 1))
    }
    
    func test_andThen_shouldNot_operateOnNoneCase() {
        // Arrange
        let didCallTransform = expectation(description: "transform was called")
        didCallTransform.isInverted = true
        
        // Act
        noneInt
            .andThen({ _ in didCallTransform.fulfill() })
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    // MARK: - mapNone
    func test_mapNone_should_operateOnNoneValue() {
        // Arrange
        let didCallTransform = expectation(description: "transform was called")
        
        // Act
        noneInt
            .mapNone({
                didCallTransform.fulfill()
                return 24}()
        )
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_mapNone_shouldNot_operateOnSomeValue() {
        // Arrange
        let didCallTransform = expectation(description: "transform was called")
        didCallTransform.isInverted = true
        
        // Act
        someInt
            .mapNone({
                didCallTransform.fulfill()
                return 24}()
        )
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_mapNone_should_returnedSameSomeForSomeValue() {
        // Act
        let result = someInt
            .mapNone(24)
        
        // Assert
        XCTAssertEqual(someInt, result)
    }
    
    // MARK: - Regular Default
    
    func test_default_should_returnDefaultValueForNoneCase() {
        // Arrange
        let defaultValue = 24
        
        // Act
        let result = noneInt
            .defaultSome(defaultValue)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(defaultValue, result)
    }
    
    func test_default_should_returnedSameSomeForSomeValue() {
        // Arrange
        let defaultValue = 24
        
        // Act
        let result = someInt
            .defaultSome(defaultValue)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(someInt, result)
    }
    
    // MARK: - Collections Properties
    
    func test_isNoneOrEmpty_property() {
        XCTAssertEqual(
            noneString.isNoneOrEmpty,
            noneString == nil || noneString!.isEmpty
        )
        XCTAssertTrue(noneString.isNoneOrEmpty)
        
        XCTAssertEqual(
            emptySomeString.isNoneOrEmpty,
            emptySomeString == nil || emptySomeString!.isEmpty
        )
        XCTAssertTrue(emptySomeString.isNoneOrEmpty)
        
        XCTAssertEqual(
            someSomeString.isNoneOrEmpty,
            someSomeString == nil || someSomeString!.isEmpty
        )
        XCTAssertFalse(someSomeString.isNoneOrEmpty)
        
        XCTAssertEqual(
            noneIntArray.isNoneOrEmpty,
            noneIntArray == nil || noneIntArray!.isEmpty
        )
        XCTAssertTrue(noneIntArray.isNoneOrEmpty)
        
        XCTAssertEqual(
            emptyIntArray.isNoneOrEmpty,
            emptyIntArray == nil || emptyIntArray!.isEmpty
        )
        XCTAssertTrue(emptyIntArray.isNoneOrEmpty)
        
        XCTAssertEqual(
            someIntArray.isNoneOrEmpty,
            someIntArray == nil || someIntArray!.isEmpty
        )
        XCTAssertFalse(someIntArray.isNoneOrEmpty)
    }
    
    func test_hasElements_property() {
        
        XCTAssertEqual(
            noneString.hasElements,
            noneString != nil && noneString!.isEmpty == false
        )
        XCTAssertFalse(noneString.hasElements)
        
        XCTAssertEqual(
            emptySomeString.hasElements,
            emptySomeString != nil && emptySomeString!.isEmpty == false
        )
        XCTAssertFalse(emptySomeString.hasElements)
        
        XCTAssertEqual(
            someSomeString.hasElements,
            someSomeString != nil && someSomeString!.isEmpty == false
        )
        XCTAssertTrue (someSomeString.hasElements)
        
        XCTAssertEqual(
            noneIntArray.hasElements,
            noneIntArray != nil && noneIntArray!.isEmpty == false
        )
        XCTAssertFalse(noneIntArray.hasElements)
        
        XCTAssertEqual(
            emptyIntArray.hasElements,
            emptyIntArray != nil && emptyIntArray!.isEmpty == false
        )
        XCTAssertFalse(emptyIntArray.hasElements)
        
        
        XCTAssertEqual(
            someIntArray.hasElements,
            someIntArray != nil && someIntArray!.isEmpty == false
        )
        XCTAssertTrue (someIntArray.hasElements)
    }
    
    func test_recoverFromEmpty_shouldNotBeCalledForNoneCase(){
        // Arrange
        let didCallTransform = expectation(description: "recover was called")
        didCallTransform.isInverted = true
        
        // Act
        noneIntArray
            .recoverFromEmpty({
                didCallTransform.fulfill()
                return [24]}()
        )
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_recoverFromEmpty_shouldNotBeCalledFor_Not_EmptyCollection(){
        // Arrange
        let didCallTransform = expectation(description: "recover was called")
        didCallTransform.isInverted = true
        
        // Act
        let stringResult =
            someSomeString
                .recoverFromEmpty({
                    didCallTransform.fulfill()
                    return "srting was empty"}())
        
        XCTAssertEqual(stringResult, someSomeString)
        
        let intArrayResult =
            someIntArray
                .recoverFromEmpty({
                    didCallTransform.fulfill()
                    return [5,10,15]}())
        
        XCTAssertEqual(intArrayResult, someIntArray)
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_recoverFromEmpty_shouldBeCalledFor_EmptyCollection(){
        // Arrange
        let didCallTransform = expectation(description: "recover was not called")
        didCallTransform.expectedFulfillmentCount = 2
        
        // Act
        let stringResult =
            emptySomeString
                .recoverFromEmpty({
                    didCallTransform.fulfill()
                    return "string was empty"}())
        
        XCTAssertEqual(stringResult, "string was empty")
        
        let intArrayResult =
            emptyIntArray
                .recoverFromEmpty({
                    didCallTransform.fulfill()
                    return [5,10,15]}())
        
        XCTAssertEqual(intArrayResult, [5,10,15])
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_default_shouldBeCalledFor_NoneOrEmptyCollection(){
        // Arrange
        let didCallTransform = expectation(description: "recover was not called")
        didCallTransform.expectedFulfillmentCount = 5
        
        let stringDefault = "default string"
        let intArrayDefault = [5,10,15]
        let intDefault = 24
        
        // Act
        XCTAssertEqual(
            noneString
                .defaultSome({
                    didCallTransform.fulfill()
                    return stringDefault}()),
            
            stringDefault
        )
        
        XCTAssertEqual(
            emptySomeString
                .defaultSome({
                    didCallTransform.fulfill()
                    return stringDefault}()),
            
            stringDefault
        )
        
        XCTAssertEqual(
            noneIntArray
                .defaultSome({
                    didCallTransform.fulfill()
                    return intArrayDefault}()),
            
            intArrayDefault
        )
        
        XCTAssertEqual(
            emptyIntArray
                .defaultSome({
                    didCallTransform.fulfill()
                    return intArrayDefault}()),
            
            intArrayDefault
        )
        
        XCTAssertEqual(
            noneInt
                .defaultSome({
                    didCallTransform.fulfill()
                    return intDefault}()),
            
            intDefault
        )
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_default_shouldNotBeCalledFor_NotEmptyCollectionsOrSomeValues(){
        // Arrange
        let didCallTransform = expectation(description: "recover was not called")
        didCallTransform.isInverted = true
        
        let stringDefault = "default string"
        let intArrayDefault = [5,10,15]
        let intDefault = 24
        
        // Act
        XCTAssertEqual(
            someSomeString
                .defaultSome({
                    didCallTransform.fulfill()
                    return stringDefault}()),
            
            someSomeString
        )
        
        XCTAssertEqual(
            someIntArray
                .defaultSome({
                    didCallTransform.fulfill()
                    return intArrayDefault}()),
            
            someIntArray
        )
        
        XCTAssertEqual(
            someInt
                .defaultSome({
                    didCallTransform.fulfill()
                    return intDefault}()),
            
            someInt
        )
        
        // Assert
        waitForExpectations(timeout: 0.5)
    }
    
    func test_randomChaining_stuff() {
        XCTAssertEqual(
            someInt
                .defaultSome(5)
                .andThen({ $0 + 1 })
                .andThen({ .none })
                .defaultSome(42),
            42,
            "Final result should equal to the last default value"
        )
        
        XCTAssertEqual(
            noneInt
                .defaultSome(5)
                .andThen({ $0 + 1 })
                .andThen({ .none })
                .defaultSome(42),
            42,
            "Final result should equal to the last default value"
        )
        
        XCTAssertEqual(
            noneInt
                .andThen({ $0 + 1 })
                .defaultSome(42),
            42,
            "Final result should equal to the last default value"
        )
    }
}
