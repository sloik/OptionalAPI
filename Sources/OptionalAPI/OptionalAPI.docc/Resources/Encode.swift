import OptionalAPI

struct Payload: Codable, Equatable {
    let value: Int
    let label: String
}

func example() {
    let payload: Payload? = .init(value: 1, label: "one")
    let data = payload.encode()
    _ = data
}
