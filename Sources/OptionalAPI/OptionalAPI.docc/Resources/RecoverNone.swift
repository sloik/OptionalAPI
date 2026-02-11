import OptionalAPI

func example(input: Int?) {
    let result = input
        .andThen { $0 + 1 }
        .mapNone(0)
        .andThen { $0 * 2 }
    _ = result
}
