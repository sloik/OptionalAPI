import Foundation

import XCTest
import OptionalAPI

final class AsyncMapNoneTests: XCTestCase {

    func test_asyncMapNone_whenSome_shouldNotCallProducer_andReturnWrappedValue() async {
        let didCallProducer = expectation(description: "producer was called")
        didCallProducer.isInverted = true

        let result = await someInt.asyncMapNone {
            didCallProducer.fulfill()
            return 69
        }

        XCTAssertEqual(result, 42)
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }

    func test_asyncMapNone_whenNone_shouldCallProducer_andReturnProducedValue() async {
        let didCallProducer = expectation(description: "producer was called")

        let result = await noneInt.asyncMapNone {
            didCallProducer.fulfill()
            try? await Task.sleep(nanoseconds: 42)
            return 69
        }

        XCTAssertEqual(result, 69)
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }
}
