// MARK: - Extension

public extension Optional {

    /// Flattens a nested optional into a single optional.
    ///
    /// In Haskell terms this is `join` from the Monad typeclass:
    /// `join :: Maybe (Maybe a) -> Maybe a`
    ///
    /// ```swift
    /// let nested: Int?? = .some(.some(42))
    /// nested.flatten() // .some(42)
    ///
    /// let outerSomeInnerNone: Int?? = .some(nil)
    /// outerSomeInnerNone.flatten() // nil
    ///
    /// let outerNone: Int?? = nil
    /// outerNone.flatten() // nil
    /// ```
    ///
    /// - Returns: The inner optional value.
    @inlinable func flatten<T>() -> T? where Wrapped == T? {
        switch self {
        case .some(let inner): return inner
        case .none: return .none
        }
    }
}

// MARK: - Free Function

/// Flattens a nested optional into a single optional.
///
/// ```swift
/// let nested: Int?? = .some(.some(42))
/// flatten(nested) // .some(42)
/// ```
@inlinable public func flatten<T>(_ nested: T??) -> T? {
    nested.flatten()
}
