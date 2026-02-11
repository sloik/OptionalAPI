import OptionalAPI

func example() {
    let value: Int? = nil

    let result = value
        .defaultSome(5)
        .andThen { $0 + 1 }
    _ = result
}
