import XCTest
@testable import OptionalAPI

let codableStruct: CodableStruct = .init(number: 69, message: "codable message")
let codableStructAsData: Data = {
    
    let jsonString: String =
    """
    {
        "number": 55,
        "message": "data message"
    }
    """
    
    return jsonString.data(using: .utf8)!
}()

final class OptionalCodableTests: XCTestCase {

    func test_shouldEncode() {
        // Arrange
        let sut: CodableStruct? = codableStruct
        
        // Act
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
    
    func test_decode_shouldReturn_noneForInvalidData() {
        // Arrange
        let sut: Data? = Data()
        
        // Act
        let result: CodableStruct? = sut.decode(CodableStruct.self)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func test_decode_shouldReturn_noneForNoneData() {
        // Arrange
        let sut: Data? = .none
        
        // Act
        let result: CodableStruct? = sut.decode(CodableStruct.self)
        
        // Assert
        XCTAssertNil(result)
    }
}
