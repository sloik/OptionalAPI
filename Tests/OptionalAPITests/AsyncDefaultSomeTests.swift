import Testing
import OptionalAPI

@Suite struct AsyncDefaultSomeTests {

    @Test func test_asyncDefaultSome_whenSome_shouldNotCallProducer_andReturnWrappedValue() async {
        let result = await confirmation("producer was called", expectedCount: 0) { confirm in
            await someInt.asyncDefaultSome {
                confirm()
                return 69
            }
        }

        #expect(result == 42)
    }

    @Test func test_asyncDefaultSome_whenNone_shouldCallProducer_andReturnProducedValue() async {
        let result = await confirmation("producer was called") { confirm in
            await noneInt.asyncDefaultSome {
                confirm()
                try? await Task.sleep(nanoseconds: 42)
                return 69
            }
        }

        #expect(result == 69)
    }
}
