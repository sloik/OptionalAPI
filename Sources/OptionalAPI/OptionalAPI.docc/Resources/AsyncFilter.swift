func example() async {
    let value: Int? = 42

    let result = await value.asyncFilter { wrapped in
        await Task.yield()
        return wrapped > 40
    }
    _ = result
}
