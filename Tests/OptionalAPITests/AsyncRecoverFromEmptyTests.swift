import Testing
import OptionalAPI

@Suite struct AsyncRecoverFromEmptyTests {

    @Test func test_asyncRecoverFromEmpty_whenEmptyCollection_shouldCallProducer() async {
        let result = await confirmation("producer was called") { confirm in
            await emptyIntArray.asyncRecoverFromEmpty {
                confirm()
                try? await Task.sleep(nanoseconds: 42)
                return [24]
            }
        }

        #expect(result == [24])
    }

    @Test func test_asyncRecoverFromEmpty_whenNotEmpty_shouldNotCallProducer() async {
        let result = await confirmation("producer was called", expectedCount: 0) { confirm in
            await someIntArray.asyncRecoverFromEmpty {
                confirm()
                return [24]
            }
        }

        #expect(result == someIntArray)
    }

    @Test func test_asyncRecoverFromEmpty_whenNone_shouldNotCallProducer() async {
        let result = await confirmation("producer was called", expectedCount: 0) { confirm in
            await noneIntArray.asyncRecoverFromEmpty {
                confirm()
                return [24]
            }
        }

        #expect(result == nil)
    }
}
