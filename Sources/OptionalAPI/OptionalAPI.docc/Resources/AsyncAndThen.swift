func example() async {
    let value: Int? = 41

    let result = await value
        .asyncAndThen { wrapped in
            await Task.yield()
            return wrapped + 1
        }
    _ = result
}
