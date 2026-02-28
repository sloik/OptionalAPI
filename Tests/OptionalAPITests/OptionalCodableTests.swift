import Foundation
import Testing
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

@Suite struct OptionalCodableTests {

    @Test func test_shouldEncode() {
        let result = sut.encode()

        #expect(result != nil)
    }

    @Test func test_shouldDecode() {
        let sutData: Data? = codableStructAsData

        let result: CodableStruct? = sutData.decode(CodableStruct.self)

        #expect(result != nil)
        #expect(result == CodableStruct(number: 55, message: "data message"))
    }

    @Test func test_shouldDecode_withDefaultType() {
        let sutData: Data? = codableStructAsData

        let result: CodableStruct? = sutData.decode()

        #expect(result != nil)
        #expect(result == CodableStruct(number: 55, message: "data message"))
    }

    @Test func test_decode_shouldReturn_noneForInvalidData() {
        let sutData: Data? = Data()

        let result: CodableStruct? = sutData.decode()

        #expect(result == nil)
    }

    @Test func test_decode_shouldReturn_noneForNoneData() {
        let sutData: Data? = .none

        let result: CodableStruct? = sutData.decode()

        #expect(result == nil)
    }

    @Test func test_asyncEncode_shouldReturnData() async {
        let result = await sut.asyncEncode()

        #expect(result != nil)
    }

    @Test func test_asyncEncode_shouldReturnNoneForNoneCase() async {
        let result = await noneCase.asyncEncode()

        #expect(result == nil)
    }

    @Test func test_asyncDecode_shouldReturn_expectedValue() async {
        let sutData: Data? = codableStructAsData

        let result: CodableStruct? = await sutData.asyncDecode()

        #expect(result == CodableStruct(number: 55, message: "data message"))
    }

    @Test func test_asyncDecode_shouldReturn_noneForNoneData() async {
        let sutData: Data? = .none

        let result: CodableStruct? = await sutData.asyncDecode()

        #expect(result == nil)
    }

    @Test func test_freeFunctions_should_yieldSameResultsAsExtension() {
        let extensionEncode = sut.encode().flatMap { data in
            try? JSONDecoder().decode(CodableStruct.self, from: data)
        }
        let functionEncode = encode(sut).flatMap { data in
            try? JSONDecoder().decode(CodableStruct.self, from: data)
        }

        #expect(extensionEncode == functionEncode)
        #expect(noneCase.encode() == encode(noneCase))

        #expect(
            codableStructAsData.decode(CodableStruct.self) == decode(codableStructAsData, CodableStruct.self)
        )
        #expect(
            codableStructAsData.decode(CodableStruct.self) == decode(CodableStruct.self)(codableStructAsData) // curried
        )

        #expect(
            noneData.decode(CodableStruct.self) == decode(noneData, CodableStruct.self)
        )
        #expect(
            noneData.decode(CodableStruct.self) == decode(CodableStruct.self)(noneData) // curried
        )
    }

    @Test func test_encodeDecode_randomStuff() {
        #expect(
            sut ==
            sut
                .encode()
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self),
            "Should not loose any information!"
        )

        #expect(
            CodableStruct(number: 55, message: "data message") ==
            codableStructAsData
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self)
                .encode()
                .decode(CodableStruct.self)
        )
    }
}
