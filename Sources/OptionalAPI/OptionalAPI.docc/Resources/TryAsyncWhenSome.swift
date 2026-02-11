func example() async throws {
    let value: Int? = 42

    try await value.tryAsyncWhenSome { wrapped in
        await Task.yield()
        print(wrapped)
    }
}
