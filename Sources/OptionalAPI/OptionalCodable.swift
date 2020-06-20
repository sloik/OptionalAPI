import Foundation

// MARK: - Extension
public extension Optional where Wrapped == Data {
    func decode<T: Decodable>(_ to: T.Type = T.self) -> T? {
        flatMap { (wrapped) -> T? in
            try? JSONDecoder().decode(T.self, from: wrapped)
        }
    }
}

public extension Optional where Wrapped: Encodable {
    func encode() -> Data? {
        flatMap { (wrapped) -> Data? in
            try? JSONEncoder().encode(wrapped)
        }
    }
}

// MARK: - Free Functions
// MARK: Decode
public func decode<T: Decodable>(
    _ optional: Data?,
    _ to: T.Type = T.self)
    -> T?
{
    optional.decode(to)
}

public func decode<T: Decodable>(
    _ to: T.Type = T.self)
    -> (Data?) -> T?
{
    return { (optional: Data?) -> T? in
        
        optional.decode(to)
    }
}


// MARK: Encode
public func encode<T: Encodable>(_ optional: T?) -> Data? {
    optional.encode()
}
