import OptionalAPI

func example(value: Int?) {
    value
        .whenSome { print("has value") }
        .whenNone { print("no value") }
}
