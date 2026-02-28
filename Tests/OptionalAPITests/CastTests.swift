import Testing
import OptionalAPI

@Suite struct CastTests {

    @Test func test_cast_should_returnCastedOptional() {
        var didCast = false

        let result: String? = anyString.cast(String.self)

        result
            .mapNone({ () -> String in
                Issue.record("Should be able to cast!")
                return "fail"
                }())
            .andThen ({ (string: String) -> String in
                didCast = true
                return string
            })

        #expect(didCast, "Should cast \(String(describing: anyString)) to String")
        #expect(result == "any string")
    }

    @Test func test_cast_shouldNot_requireTypeParameterWhenItCanBeInferred() {
        let result: String? = anyString.cast()

        #expect(result != nil)
    }

    @Test func test_cast_shouldReturn_NoneForFailedCast() {
        let result: Int? = anyString.cast(Int.self)

        result
            .andThen ({ (number: Int) -> Int in
                Issue.record("Should NOT cast!")
                return number
            })

        #expect(result == nil)
    }

    @Test func test_cast_toDifferentType_shouldReturn_NoneForNone() {
        let result: Int? = anyNoneString.cast(Int.self)

        result
            .andThen ({ (number: Int) -> Int in
                Issue.record("Should NOT cast!")
                return number
            })

        #expect(result == nil)
    }

    @Test func test_cast_toSameType_shouldReturn_NoneForNone() {
        let result: String? = anyNoneString.cast(String.self)

        result
            .andThen ({ (string: String) -> String in
                Issue.record("Should NOT cast!")
                return string
            })

        #expect(result == nil)
    }

    @Test func test_cast_shouldProduce_sameResultAsInlinedCast() {
        #expect(
            noneString.andThen({ $0 as? String }) == noneString.cast(String.self)
        )
        #expect(
            noneString.andThen({ $0 as? Int }) == noneString.cast(Int.self)
        )

        #expect(
            anyString.andThen({ $0 as? String }) == anyString.cast(String.self)
        )
        #expect(
            anyString.andThen({ $0 as? Int }) == anyString.cast(Int.self)
        )

        #expect(
            anyNoneString.andThen({ $0 as? String }) == anyNoneString.cast(String.self)
        )
        #expect(
            anyNoneString.andThen({ $0 as? Int }) == anyNoneString.cast(Int.self)
        )

        #expect(
            anyInt.andThen({ $0 as? String }) == anyInt.cast(String.self)
        )
        #expect(
            anyInt.andThen({ $0 as? Int }) == anyInt.cast(Int.self)
        )

        #expect(
            anyNoneInt.andThen({ $0 as? String }) == anyNoneInt.cast(String.self)
        )
        #expect(
            anyNoneInt.andThen({ $0 as? Int }) == anyNoneInt.cast(Int.self)
        )
    }

    @Test func test_randomCombinators() {
        #expect(
            anyInt
                .cast(Int.self)
                .andThen({ $0 + 1 }) == 43
        )

        #expect(
            anyString
                .cast(String.self)
                .andThen({ $0.uppercased() }) == "ANY STRING"
        )
    }
}
