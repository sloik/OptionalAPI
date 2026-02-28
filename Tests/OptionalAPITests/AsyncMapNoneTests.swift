import Testing
import OptionalAPI

@Suite struct AsyncMapNoneTests {

    @Test func test_asyncMapNone_whenSome_shouldNotCallProducer_andReturnWrappedValue() async {
        let result = await confirmation("producer was called", expectedCount: 0) { confirm in
            await someInt.asyncMapNone {
                confirm()
                return 69
            }
        }

        #expect(result == 42)
    }

    @Test func test_asyncMapNone_whenNone_shouldCallProducer_andReturnProducedValue() async {
        let result = await confirmation("producer was called") { confirm in
            await noneInt.asyncMapNone {
                confirm()
                try? await Task.sleep(nanoseconds: 42)
                return 69
            }
        }

        #expect(result == 69)
    }
}
