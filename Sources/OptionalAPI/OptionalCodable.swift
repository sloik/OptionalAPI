import Foundation

extension Optional where Wrapped == Data {
    func decode<T: Decodable>(_ to: T.Type) -> T? {
        flatMap { (wrapped) -> T? in
            try? JSONDecoder().decode(T.self, from: wrapped)
        }
    }
}

extension Optional where Wrapped: Encodable {
    func encode() -> Data? {
        flatMap { (wrapped) -> Data? in
            try? JSONEncoder().encode(wrapped)
        }
    }
}
