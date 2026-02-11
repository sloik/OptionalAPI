import OptionalAPI

func example() {
    let emptyArray: [Int]? = []

    let result = emptyArray.recoverFromEmpty([1, 2, 3])
    _ = result
}
