import Testing
@testable import OptionalAPI

@Suite struct OptionalAPITests {

    @Test func test_isNone_property() throws {
        #expect(noneInt.isNone == (noneInt == nil))
        #expect(someInt.isNone == (someInt == nil))
        #expect(noneString.isNone == (noneString == nil))
        #expect(emptySomeString.isNone == (emptySomeString == nil))
        #expect(someSomeString.isNone == (someSomeString == nil))
        #expect(noneIntArray.isNone == (noneIntArray == nil))
        #expect(emptyIntArray.isNone == (emptyIntArray == nil))
        #expect(someIntArray.isNone == (someIntArray == nil))
    }

    @Test func test_isSome_property() throws {
        #expect(noneInt.isSome == (noneInt != nil))
        #expect(someInt.isSome == (someInt != nil))
        #expect(noneString.isSome == (noneString != nil))
        #expect(emptySomeString.isSome == (emptySomeString != nil))
        #expect(someSomeString.isSome == (someSomeString != nil))
        #expect(noneIntArray.isSome == (noneIntArray != nil))
        #expect(emptyIntArray.isSome == (emptyIntArray != nil))
        #expect(someIntArray.isSome == (someIntArray != nil))
    }

    @Test func test_isNotNone_property() throws {
        #expect(!noneInt.isNotNone)
        #expect(noneInt.isNotNone == (noneInt != nil))

        #expect(someInt.isNotNone)
        #expect(someInt.isNotNone == (someInt != nil))
    }

    @Test func test_isNotSome_property() throws {
        #expect(noneInt.isNotSome)
        #expect(noneInt.isNotSome == (noneInt == nil))

        #expect(someInt.isNotSome == (someInt == nil))
    }

    @Test func test_or_shouldNotChangeSome() {
        #expect(someInt.or(69) == someInt)
    }

    @Test func test_or_shouldGiveDefaultValue() {
        #expect(noneInt.or(69) == 69)
    }

    @Test func test_andThen_should_operateOnWrappedValue() async {
        await confirmation("transform was called") { confirm in
            someInt.andThen({ _ in confirm() })
        }
    }

    @Test func test_andThen_should_callEachAndThenBlockForSomeCases() async {
        await confirmation("transform was called", expectedCount: 3) { confirm in
            someInt
                .andThen({ (wrapped: Int) -> Int in
                    confirm()
                    return wrapped
                })
                .andThen({ (wrapped: Int) -> Int in
                    confirm()
                    return wrapped
                })
                .andThen({ (wrapped: Int) -> Int in
                    confirm()
                    return wrapped
                })
        }
    }

    @Test func test_andThen_should_passInTheWrappedValue() {
        var accumulator: [Int] = []

        someInt.andThen({ wrapped in accumulator.append(wrapped) })

        #expect(accumulator == [42])
    }

    @Test func test_andThen_should_returnedTransformedValue() {
        let result = someInt.andThen({ wrapped in wrapped + 1 })

        #expect(result == .some(42 + 1))
    }

    @Test func test_andThen_shouldNot_operateOnNoneCase() async {
        await confirmation("transform was called", expectedCount: 0) { confirm in
            noneInt.andThen({ _ in confirm() })
        }
    }

    @Test func test_mapNone_should_operateOnNoneValue() async {
        await confirmation("transform was called") { confirm in
            noneInt.mapNone({
                confirm()
                return 24
            }())
        }
    }

    @Test func test_mapNone_shouldNot_operateOnSomeValue() async {
        await confirmation("transform was called", expectedCount: 0) { confirm in
            someInt.mapNone({
                confirm()
                return 24
            }())
        }
    }

    @Test func test_mapNone_should_returnedSameSomeForSomeValue() {
        let result = someInt.mapNone(24)

        #expect(someInt == result)
    }

    @Test func test_default_should_returnDefaultValueForNoneCase() {
        let defaultValue = 24

        let result = noneInt.defaultSome(defaultValue)

        #expect(result != nil)
        #expect(defaultValue == result)
    }

    @Test func test_default_should_returnedSameSomeForSomeValue() {
        let defaultValue = 24

        let result = someInt.defaultSome(defaultValue)

        #expect(result != nil)
        #expect(someInt == result)
    }

    @Test func test_or_typeShouldBe_wrapped() {
        var intExpected: Int = someInt.or(69)
        intExpected = noneInt.or(69)

        #expect(intExpected is Int)
    }

    @Test func test_or_forNone_shouldReturn_providedDefault() {
        #expect(noneInt.or(69) == 69)
        #expect(noneString.or("default string") == "default string")
    }

    @Test func test_or_forSome_shouldReturn_wrappedValue() {
        #expect(someInt.or(69) == 42)
        #expect(someSomeString.or("default string") == "some string")
    }

    @Test func test_asyncFold_whenSome_shouldReturnTransformedValue() async {
        let result = await someInt.asyncFold(0) { value in
            try? await Task.sleep(nanoseconds: 42)
            return value + 1
        }

        #expect(result == 43)
    }

    @Test func test_asyncFold_whenNone_shouldReturnNoneCase() async {
        let result = await noneInt.asyncFold(24) { value in
            try? await Task.sleep(nanoseconds: 42)
            return value + 1
        }

        #expect(result == 24)
    }

    @Test func test_isNoneOrEmpty_property() {
        #expect(noneString.isNoneOrEmpty == (noneString == nil || noneString!.isEmpty))
        #expect(noneString.isNoneOrEmpty)

        #expect(emptySomeString.isNoneOrEmpty == (emptySomeString == nil || emptySomeString!.isEmpty))
        #expect(emptySomeString.isNoneOrEmpty)

        #expect(someSomeString.isNoneOrEmpty == (someSomeString == nil || someSomeString!.isEmpty))
        #expect(!someSomeString.isNoneOrEmpty)

        #expect(noneIntArray.isNoneOrEmpty == (noneIntArray == nil || noneIntArray!.isEmpty))
        #expect(noneIntArray.isNoneOrEmpty)

        #expect(emptyIntArray.isNoneOrEmpty == (emptyIntArray == nil || emptyIntArray!.isEmpty))
        #expect(emptyIntArray.isNoneOrEmpty)

        #expect(someIntArray.isNoneOrEmpty == (someIntArray == nil || someIntArray!.isEmpty))
        #expect(!someIntArray.isNoneOrEmpty)
    }

    @Test func test_hasElements_property() {
        #expect(noneString.hasElements == (noneString != nil && noneString!.isEmpty == false))
        #expect(!noneString.hasElements)

        #expect(emptySomeString.hasElements == (emptySomeString != nil && emptySomeString!.isEmpty == false))
        #expect(!emptySomeString.hasElements)

        #expect(someSomeString.hasElements == (someSomeString != nil && someSomeString!.isEmpty == false))
        #expect(someSomeString.hasElements)

        #expect(noneIntArray.hasElements == (noneIntArray != nil && noneIntArray!.isEmpty == false))
        #expect(!noneIntArray.hasElements)

        #expect(emptyIntArray.hasElements == (emptyIntArray != nil && emptyIntArray!.isEmpty == false))
        #expect(!emptyIntArray.hasElements)

        #expect(someIntArray.hasElements == (someIntArray != nil && someIntArray!.isEmpty == false))
        #expect(someIntArray.hasElements)
    }

    @Test func test_recoverFromEmpty_shouldNotBeCalledForNoneCase() async {
        await confirmation("recover was called", expectedCount: 0) { confirm in
            noneIntArray.recoverFromEmpty({
                confirm()
                return [24]
            }())
        }
    }

    @Test func test_recoverFromEmpty_shouldNotBeCalledFor_Not_EmptyCollection() async {
        await confirmation("recover was called", expectedCount: 0) { confirm in
            let stringResult =
                someSomeString
                    .recoverFromEmpty({
                        confirm()
                        return "srting was empty"
                    }())

            #expect(stringResult == someSomeString)

            let intArrayResult =
                someIntArray
                    .recoverFromEmpty({
                        confirm()
                        return [5, 10, 15]
                    }())

            #expect(intArrayResult == someIntArray)
        }
    }

    @Test func test_recoverFromEmpty_shouldBeCalledFor_EmptyCollection() async {
        await confirmation("recover was not called", expectedCount: 2) { confirm in
            let stringResult =
                emptySomeString
                    .recoverFromEmpty({
                        confirm()
                        return "string was empty"
                    }())

            #expect(stringResult == "string was empty")

            let intArrayResult =
                emptyIntArray
                    .recoverFromEmpty({
                        confirm()
                        return [5, 10, 15]
                    }())

            #expect(intArrayResult == [5, 10, 15])
        }
    }

    @Test func test_default_shouldNotBeCalledFor_NotEmptyCollectionsOrSomeValues() async {
        let stringDefault = "default string"
        let intArrayDefault = [5, 10, 15]
        let intDefault = 24

        await confirmation("recover was not called", expectedCount: 0) { confirm in
            #expect(
                someSomeString
                    .defaultSome({
                        confirm()
                        return stringDefault
                    }()) == someSomeString
            )

            #expect(
                someIntArray
                    .defaultSome({
                        confirm()
                        return intArrayDefault
                    }()) == someIntArray
            )

            #expect(
                someInt
                    .defaultSome({
                        confirm()
                        return intDefault
                    }()) == someInt
            )
        }
    }
}
