import Testing
import OptionalAPI

@Suite struct AsyncOrTests {

    @Test func test_asyncOr_whenSome_shouldNotCallProducer_andReturnWrappedValue() async {
        let result = await confirmation("producer was called", expectedCount: 0) { confirm in
            await someInt.asyncOr {
                confirm()
                return 69
            }
        }

        #expect(result == 42)
    }

    @Test func test_asyncOr_whenNone_shouldCallProducer_andReturnProducedValue() async {
        let result = await confirmation("producer was called") { confirm in
            await noneInt.asyncOr {
                confirm()
                try? await Task.sleep(nanoseconds: 42)
                return 69
            }
        }

        #expect(result == 69)
    }
}
