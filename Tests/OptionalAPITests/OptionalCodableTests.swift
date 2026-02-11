import XCTest
@testable import OptionalAPI

let codableStruct: CodableStruct = .init(number: 69, message: "codable message")

let sut     : CodableStruct? = codableStruct
let noneCase: CodableStruct? = .none

let codableStructAsData: Data? =
    """
    {
        "number": 55,
        "message": "data message"
    }
    """.data(using: .utf8)!
let noneData: Data? = .none


final class OptionalCodableTests: XCTestCase {

    func test_shouldEncode() {
        // Arrange & Act
        let result = sut.encode()
        
        // Assert
        XCTAssertNotNil(result)
    }
    
    func test_shouldDecode() {
        // Arrange
        let sut: Data? = codableStructAsData
        
        // Act
        let result: CodableStruct? = sut.decode(CodableStruct.self)
        
        // Assert
        XCTAssertNotNil(result)
        
        XCTAssertEqual(
            result,
            CodableStruct(number: 55, message: "data message")
        )
    }
    
    func test_shouldDecode_withDefaultType() {
        // Arrange
        let sut: Data? = codableStructAsData
        
        // Act
        let result: CodableStruct? = sut.decode()
        
        // Assert
        XCTAssertNotNil(result)
        
        XCTAssertEqual(
            result,
            CodableStruct(number: 55, message: "data message")
        )
    }
    
    func test_decode_shouldReturn_noneForInvalidData() {
        // Arrange
        let sut: Data? = Data()
        
        // Act
        let result: CodableStruct? = sut.decode()
        
        // Assert
        XCTAssertNil(result)
    }
    
    func test_decode_shouldReturn_noneForNoneData() {
        // Arrange
        let sut: Data? = .none
        
        // Act
        let result: CodableStruct? = sut.decode()
        
        // Assert
        XCTAssertNil(result)
    }

    func test_asyncEncode_shouldReturnData() async {
        let result = await sut.asyncEncode()

        XCTAssertNotNil(result)
    }

    func test_asyncEncode_shouldReturnNoneForNoneCase() async {
        let result = await noneCase.asyncEncode()

        XCTAssertNil(result)
    }
    
    func test_freeFunctions_should_yieldSameResultsAsExtension() {
        // MARK: Encode
        XCTAssertEqual(
            sut.encode()!,
            encode(sut)!
        )
        
        XCTAssertEqual(
            noneCase.encode(),
            encode(noneCase)
        )
        
        // MARK: Decode
        XCTAssertEqual(
            codableStructAsData.decode(CodableStruct.self),
            decode(codableStructAsData, CodableStruct.self)
        )
        XCTAssertEqual(
            codableStructAsData.decode(CodableStruct.self),
            decode(CodableStruct.self)(codableStructAsData) // curried
        )
        
        XCTAssertEqual(
            noneData.decode(CodableStruct.self),
            decode(noneData, CodableStruct.self)
        )
        XCTAssertEqual(
            noneData.decode(CodableStruct.self),
            decode(CodableStruct.self)(noneData) // curried
        )
    }
    
    func test_encodeDecode_randomStuff() {
        XCTAssertEqual(
            sut,
            sut
                .encode()
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self),
            "Should not loose any information!"
        )
        
        XCTAssertEqual(
            CodableStruct(number: 55, message: "data message"),
            codableStructAsData
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self)
        )
    }
}
