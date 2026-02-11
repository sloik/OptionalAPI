import Foundation

import XCTest
import OptionalAPI

final class AsyncDefaultSomeTests: XCTestCase {

    func test_asyncDefaultSome_whenSome_shouldNotCallProducer_andReturnWrappedValue() async {
        let didCallProducer = expectation(description: "producer was called")
        didCallProducer.isInverted = true

        let result = await someInt.asyncDefaultSome {
            didCallProducer.fulfill()
            return 69
        }

        XCTAssertEqual(result, 42)
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }

    func test_asyncDefaultSome_whenNone_shouldCallProducer_andReturnProducedValue() async {
        let didCallProducer = expectation(description: "producer was called")

        let result = await noneInt.asyncDefaultSome {
            didCallProducer.fulfill()
            try? await Task.sleep(nanoseconds: 42)
            return 69
        }

        XCTAssertEqual(result, 69)
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }
}
