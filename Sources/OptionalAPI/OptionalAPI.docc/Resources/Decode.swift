import Foundation
import OptionalAPI

struct Payload: Codable, Equatable {
    let value: Int
    let label: String
}

func example() {
    let data: Data? = """
    {"value":1,"label":"one"}
    """.data(using: .utf8)
    let decoded: Payload? = data.decode()
    _ = decoded
}
