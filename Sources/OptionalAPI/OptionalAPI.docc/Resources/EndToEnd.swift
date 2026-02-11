import OptionalAPI

struct Payload: Codable, Equatable {
    let value: Int
    let label: String
}

func enrich(_ value: Int) async -> String {
    await Task.yield()
    return "value-\(value)"
}

func example() async {
    let input: Int? = 41

    let payloadData = await input
        .andThen { $0 + 1 }
        .filter { $0 > 0 }
        .asyncAndThen { value in
            let label = await enrich(value)
            return Payload(value: value, label: label)
        }
        .encode()
    _ = payloadData
}
