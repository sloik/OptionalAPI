import OptionalAPI

func example() {
    let noneString: String? = nil
    let emptyString: String? = ""
    let someString: String? = "text"

    _ = noneString.hasElements      // false
    _ = emptyString.hasElements     // false
    _ = someString.hasElements      // true

    _ = noneString.isNoneOrEmpty    // true
    _ = emptyString.isNoneOrEmpty   // true
    _ = someString.isNoneOrEmpty    // false
}
