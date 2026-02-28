import Testing
@testable import OptionalAPI

@Suite struct TraversableTests {

    @Test func test_sequence_allSome_returnsSomeArray() {
        let optionals: [Int?] = [1, 2, 3]

        let result = sequence(optionals)

        #expect(result == [1, 2, 3])
    }

    @Test func test_sequence_hasNone_returnsNone() {
        let optionals: [Int?] = [1, nil, 3]

        let result = sequence(optionals)

        #expect(result == nil)
    }

    @Test func test_sequence_allNone_returnsNone() {
        let optionals: [Int?] = [nil, nil, nil]

        let result = sequence(optionals)

        #expect(result == nil)
    }

    @Test func test_sequence_emptyArray_returnsSomeEmpty() {
        let optionals: [Int?] = []

        let result = sequence(optionals)

        #expect(result == [])
    }

    @Test func test_sequence_singleSome_returnsSingleArray() {
        let optionals: [Int?] = [42]

        let result = sequence(optionals)

        #expect(result == [42])
    }

    @Test func test_sequence_singleNone_returnsNone() {
        let optionals: [Int?] = [nil]

        let result = sequence(optionals)

        #expect(result == nil)
    }

    @Test func test_sequenceExtension_allSome_returnsSomeArray() {
        let optionals: [Int?] = [1, 2, 3]

        let result: [Int]? = optionals.sequence()

        #expect(result == [1, 2, 3])
    }

    @Test func test_sequenceExtension_hasNone_returnsNone() {
        let optionals: [Int?] = [1, nil, 3]

        let result: [Int]? = optionals.sequence()

        #expect(result == nil)
    }

    @Test func test_traverse_allSucceed_returnsSomeArray() {
        let strings = ["1", "2", "3"]

        let result = traverse(strings) { Int($0) }

        #expect(result == [1, 2, 3])
    }

    @Test func test_traverse_someFail_returnsNone() {
        let strings = ["1", "abc", "3"]

        let result = traverse(strings) { Int($0) }

        #expect(result == nil)
    }

    @Test func test_traverse_emptyArray_returnsSomeEmpty() {
        let strings: [String] = []

        let result = traverse(strings) { Int($0) }

        #expect(result == [])
    }

    @Test func test_traverse_allFail_returnsNone() {
        let strings = ["abc", "def"]

        let result = traverse(strings) { Int($0) }

        #expect(result == nil)
    }

    @Test func test_traverse_curried() {
        let parseInt: ([String]) -> [Int]? = traverse { Int($0) }

        #expect(parseInt(["1", "2"]) == [1, 2])
        #expect(parseInt(["1", "abc"]) == nil)
    }

    @Test func test_traverseExtension_allSucceed() {
        let result = ["1", "2", "3"].traverse { Int($0) }

        #expect(result == [1, 2, 3])
    }

    @Test func test_traverseExtension_someFail() {
        let result = ["1", "abc"].traverse { Int($0) }

        #expect(result == nil)
    }
}
