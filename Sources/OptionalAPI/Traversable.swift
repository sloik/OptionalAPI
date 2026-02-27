
// MARK: - Free Functions

/// Converts an array of optionals into an optional array.
///
/// If all elements are `.some`, returns `.some` with all values unwrapped.
/// If any element is `.none`, returns `.none`.
///
/// In Haskell terms: `sequence :: [Maybe a] -> Maybe [a]`
///
/// ```swift
/// let allSome: [Int?] = [1, 2, 3]
/// sequence(allSome) // .some([1, 2, 3])
///
/// let hasNone: [Int?] = [1, nil, 3]
/// sequence(hasNone) // nil
///
/// let empty: [Int?] = []
/// sequence(empty) // .some([])
/// ```
///
/// - Parameter optionals: An array of optional values.
/// - Returns: An optional array containing all unwrapped values, or `.none` if any was `.none`.
@inlinable public func sequence<T>(_ optionals: [T?]) -> [T]? {
    var result: [T] = []
    result.reserveCapacity(optionals.count)

    for optional in optionals {
        switch optional {
        case .some(let value):
            result.append(value)
        case .none:
            return nil
        }
    }

    return result
}

/// Maps a transform over an array and sequences the result.
///
/// Applies `transform` to each element, collecting the results. If any transform
/// returns `.none`, the entire result is `.none`.
///
/// In Haskell terms: `traverse :: (a -> Maybe b) -> [a] -> Maybe [b]`
///
/// ```swift
/// let strings = ["1", "2", "3"]
/// traverse(strings) { Int($0) } // .some([1, 2, 3])
///
/// let mixed = ["1", "abc", "3"]
/// traverse(mixed) { Int($0) } // nil
/// ```
///
/// - Parameters:
///   - values: The array of values to transform.
///   - transform: A function that may fail (returns optional).
/// - Returns: An optional array of transformed values, or `.none` if any failed.
@inlinable public func traverse<A, B>(_ values: [A], _ transform: (A) -> B?) -> [B]? {
    var result: [B] = []
    result.reserveCapacity(values.count)

    for value in values {
        switch transform(value) {
        case .some(let transformed):
            result.append(transformed)
        case .none:
            return nil
        }
    }

    return result
}

/// Curried version of `traverse` for point-free composition.
@inlinable public func traverse<A, B>(_ transform: @escaping (A) -> B?) -> ([A]) -> [B]? {
    return { values in
        traverse(values, transform)
    }
}

// MARK: - Array Extension

public extension Array {

    /// Applies a transform to each element and sequences the results.
    ///
    /// If any transform returns `.none`, the entire result is `.none`.
    ///
    /// ```swift
    /// ["1", "2", "3"].traverse { Int($0) } // .some([1, 2, 3])
    /// ["1", "abc"].traverse { Int($0) }    // nil
    /// ```
    ///
    /// - Parameter transform: A function that may return `.none`.
    /// - Returns: An optional array of transformed values.
    @inlinable func traverse<B>(_ transform: (Element) -> B?) -> [B]? {
        OptionalAPI.traverse(self, transform)
    }
}

public extension Array {

    /// Unwraps all optionals in the array, or returns `.none` if any is nil.
    ///
    /// ```swift
    /// let values: [Int?] = [1, 2, 3]
    /// values.sequence() // .some([1, 2, 3])
    ///
    /// let mixed: [Int?] = [1, nil, 3]
    /// mixed.sequence() // nil
    /// ```
    ///
    /// - Returns: An optional array of unwrapped values.
    @inlinable func sequence<T>() -> [T]? where Element == T? {
        OptionalAPI.sequence(self)
    }
}
