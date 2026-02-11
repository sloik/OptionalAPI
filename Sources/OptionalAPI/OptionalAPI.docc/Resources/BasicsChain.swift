import OptionalAPI

func example() {
    let value: Int? = 10

    let result = value
        .andThen { $0 + 1 }
        .mapNone(0)
        .andThen { $0 * 2 }
    _ = result
}
