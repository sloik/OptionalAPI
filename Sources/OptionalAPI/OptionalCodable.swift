import Foundation

// MARK: - Extension

public extension Optional where Wrapped == Data {

    /// Decodes wrapped data to desired Decodable type.
    /// - Parameter to: Type that is conforming to `Decodable`.
    /// - Returns: Instance of `T` if JSONDecoder decode succeeded or .none otherwise.
    ///
    /// ```swift
    /// let codableStructAsData: Data? = ...
    ///
    /// let result: CodableStruct? = codableStructAsData.decode()
    /// ```
    /// Type can be inferred so it does not have to be added explicitly. Same can
    /// be written as:
    /// ```swift
    /// let result = codableStructAsData.decode(CodableStruct.self)
    /// ```
    /// Either way is fine and you will have an optional to work with.
    /// ```swift
    /// codableStructAsData
    ///     .decode(CodableStruct.self)
    ///     .andThen({ instance in
    ///         // work with not optional instance
    ///     })
    /// ```
    @inlinable func decode<T: Decodable>(_ to: T.Type = T.self) -> T? {
        flatMap { (wrapped) -> T? in
            try? JSONDecoder().decode(T.self, from: wrapped)
        }
    }

    /// Asynchronous version of `decode`.
    /// - Parameter to: Type that is conforming to `Decodable`.
    /// - Returns: Instance of `T` if JSONDecoder decode succeeded or .none otherwise.
    ///
    /// ```swift
    /// let codableStructAsData: Data? = ...
    /// let result: CodableStruct? = await codableStructAsData.asyncDecode()
    /// ```
    @inlinable func asyncDecode<T: Decodable>(_ to: T.Type = T.self) async -> T? {
        switch self {
        case .some(let wrapped):
            return try? JSONDecoder().decode(T.self, from: wrapped)
        case .none:
            return .none
        }
    }
}


public extension Optional where Wrapped: Encodable {

    /// Encodes wrapped value to Data.
    /// - Returns: Data if JSONEncoder encode succeeded or .none otherwise.
    @inlinable func encode() -> Data? {
        flatMap { (wrapped) -> Data? in
            try? JSONEncoder().encode(wrapped)
        }
    }

    /// Asynchronous version of `encode`.
    /// - Returns: Data if JSONEncoder encode succeeded or .none otherwise.
    ///
    /// ```swift
    /// let value: CodableStruct? = ...
    /// let data = await value.asyncEncode()
    /// ```
    @inlinable func asyncEncode() async -> Data? {
        switch self {
        case .some(let wrapped):
            return try? JSONEncoder().encode(wrapped)
        case .none:
            return .none
        }
    }
}

// MARK: - Free Functions
// MARK: Decode


/// Decodes wrapped data to desired Decodable type.
/// - Parameters:
///   - optional: Instance of `Data?` type.
///   - to: Type that is conforming to `Decodable`.
/// - Returns: Instance of `T` if JSONDecoder decode succeeded or `.none` otherwise.
@inlinable public func decode<T: Decodable>(
    _ optional: Data?,
    _ to: T.Type = T.self)
    -> T?
{
    optional.decode(to)
}


/// Curried version of `decode` function
/// - Parameter to:  Type that is conforming to `Decodable`.
/// - Returns: Function that given `Data?` will produce instance of `T` if JSONDecoder decode succeeded or `.none` otherwise.
@inlinable public func decode<T: Decodable>(
    _ to: T.Type = T.self)
    -> (Data?) -> T?
{
    return { (optional: Data?) -> T? in
        optional.decode(to)
    }
}


// MARK: Encode

/// Encodes wrapped value to Data.
/// - Parameter optional: Instance to be encoded.
/// - Returns: Data if JSONEncoder encode succeeded or `.none` otherwise.
@inlinable public func encode<T: Encodable>(_ optional: T?) -> Data? {
    optional.encode()
}
