import OptionalAPI

func example(input: Int?) {
    input
        .whenSome { value in
            print("Got value: \(value)")
        }
        .whenNone {
            print("No value")
        }
}
