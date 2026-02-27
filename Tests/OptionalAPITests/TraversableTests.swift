import XCTest
@testable import OptionalAPI

final class TraversableTests: XCTestCase {

    // MARK: - sequence free function

    func test_sequence_allSome_returnsSomeArray() {
        let optionals: [Int?] = [1, 2, 3]

        let result = sequence(optionals)

        XCTAssertEqual(result, [1, 2, 3])
    }

    func test_sequence_hasNone_returnsNone() {
        let optionals: [Int?] = [1, nil, 3]

        let result = sequence(optionals)

        XCTAssertNil(result)
    }

    func test_sequence_allNone_returnsNone() {
        let optionals: [Int?] = [nil, nil, nil]

        let result = sequence(optionals)

        XCTAssertNil(result)
    }

    func test_sequence_emptyArray_returnsSomeEmpty() {
        let optionals: [Int?] = []

        let result = sequence(optionals)

        XCTAssertEqual(result, [])
    }

    func test_sequence_singleSome_returnsSingleArray() {
        let optionals: [Int?] = [42]

        let result = sequence(optionals)

        XCTAssertEqual(result, [42])
    }

    func test_sequence_singleNone_returnsNone() {
        let optionals: [Int?] = [nil]

        let result = sequence(optionals)

        XCTAssertNil(result)
    }

    // MARK: - sequence Array extension

    func test_sequenceExtension_allSome_returnsSomeArray() {
        let optionals: [Int?] = [1, 2, 3]

        let result: [Int]? = optionals.sequence()

        XCTAssertEqual(result, [1, 2, 3])
    }

    func test_sequenceExtension_hasNone_returnsNone() {
        let optionals: [Int?] = [1, nil, 3]

        let result: [Int]? = optionals.sequence()

        XCTAssertNil(result)
    }

    // MARK: - traverse free function

    func test_traverse_allSucceed_returnsSomeArray() {
        let strings = ["1", "2", "3"]

        let result = traverse(strings) { Int($0) }

        XCTAssertEqual(result, [1, 2, 3])
    }

    func test_traverse_someFail_returnsNone() {
        let strings = ["1", "abc", "3"]

        let result = traverse(strings) { Int($0) }

        XCTAssertNil(result)
    }

    func test_traverse_emptyArray_returnsSomeEmpty() {
        let strings: [String] = []

        let result = traverse(strings) { Int($0) }

        XCTAssertEqual(result, [])
    }

    func test_traverse_allFail_returnsNone() {
        let strings = ["abc", "def"]

        let result = traverse(strings) { Int($0) }

        XCTAssertNil(result)
    }

    // MARK: - traverse curried

    func test_traverse_curried() {
        let parseInt: ([String]) -> [Int]? = traverse { Int($0) }

        XCTAssertEqual(parseInt(["1", "2"]), [1, 2])
        XCTAssertNil(parseInt(["1", "abc"]))
    }

    // MARK: - traverse Array extension

    func test_traverseExtension_allSucceed() {
        let result = ["1", "2", "3"].traverse { Int($0) }

        XCTAssertEqual(result, [1, 2, 3])
    }

    func test_traverseExtension_someFail() {
        let result = ["1", "abc"].traverse { Int($0) }

        XCTAssertNil(result)
    }
}
