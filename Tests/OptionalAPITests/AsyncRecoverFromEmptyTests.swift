import Foundation

import XCTest
import OptionalAPI

final class AsyncRecoverFromEmptyTests: XCTestCase {

    func test_asyncRecoverFromEmpty_whenEmptyCollection_shouldCallProducer() async {
        let didCallProducer = expectation(description: "producer was called")

        let result = await emptyIntArray.asyncRecoverFromEmpty {
            didCallProducer.fulfill()
            try? await Task.sleep(nanoseconds: 42)
            return [24]
        }

        XCTAssertEqual(result, [24])
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }

    func test_asyncRecoverFromEmpty_whenNotEmpty_shouldNotCallProducer() async {
        let didCallProducer = expectation(description: "producer was called")
        didCallProducer.isInverted = true

        let result = await someIntArray.asyncRecoverFromEmpty {
            didCallProducer.fulfill()
            return [24]
        }

        XCTAssertEqual(result, someIntArray)
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }

    func test_asyncRecoverFromEmpty_whenNone_shouldNotCallProducer() async {
        let didCallProducer = expectation(description: "producer was called")
        didCallProducer.isInverted = true

        let result = await noneIntArray.asyncRecoverFromEmpty {
            didCallProducer.fulfill()
            return [24]
        }

        XCTAssertNil(result)
        await fulfillment(of: [didCallProducer], timeout: 0.5)
    }
}
