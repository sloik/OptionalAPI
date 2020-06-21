import Foundation

// MARK: - Extension
public extension Optional where Wrapped == Data {
    
    /// Decodes wrapped data to desired Decodable type.
    /// - Parameter to: Type that is conforming to `Decodable`.
    /// - Returns: Instance of `T` if JSONDecoder decode succeeded or .none otherwise.
    ///
    /// ```
    /// let codableStructAsData: Data? = ...
    ///
    /// let result: CodableStruct? = codableStructAsData.decode()
    /// ```
    /// Type can be inferred so it does not have to be added explicitly. Same can
    /// be written as:
    /// ```
    /// let result = codableStructAsData.decode(CodableStruct.self)
    /// ```
    /// Either way is fine and you will have an optional to work with.
    /// ```
    /// codableStructAsData
    ///     .decode(CodableStruct.self)
    ///     .andThen({ instance in
    ///         // work with not optional instance
    ///     })
    /// ```
    func decode<T: Decodable>(_ to: T.Type = T.self) -> T? {
        flatMap { (wrapped) -> T? in
            try? JSONDecoder().decode(T.self, from: wrapped)
        }
    }
}

public extension Optional where Wrapped: Encodable {
    
    /// Encodes wrapped value to Data.
    /// - Returns: Data if JSONEncoder encode succeeded or .none otherwise.
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
