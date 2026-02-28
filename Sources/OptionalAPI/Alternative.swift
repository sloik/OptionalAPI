// MARK: - Extension

public extension Optional {

    /// Alternative: returns self if `.some`, otherwise returns the other optional.
    ///
    /// Unlike `or` which unwraps to `Wrapped`, this stays in `Optional` land.
    /// In Haskell terms this is `<|>` from the Alternative typeclass.
    ///
    /// ```swift
    /// let first: Int? = nil
    /// let second: Int? = 42
    /// first.orOptional(second) // .some(42)
    ///
    /// let both: Int? = 10
    /// both.orOptional(second) // .some(10)
    /// ```
    ///
    /// - Parameter other: A lazily evaluated alternative optional.
    /// - Returns: Self if `.some`, otherwise the alternative.
    @inlinable @discardableResult
    func orOptional(_ other: @autoclosure () -> Wrapped?) -> Wrapped? {
        switch self {
        case .some: return self
        case .none: return other()
        }
    }

    /// Async version of `orOptional`.
    ///
    /// Returns `self` when `.some`, otherwise awaits the `other` closure and returns its result.
    /// The fallback is only evaluated when needed.
    ///
    /// ```swift
    /// let primary: Int? = nil
    /// let result = await primary.asyncOrOptional {
    ///     await fetchFallback()
    /// }
    /// ```
    ///
    /// - Parameter other: An async closure producing an alternative optional.
    /// - Returns: Self if `.some`, otherwise the result of `other()`.
    /// - Note: The closure is `@Sendable` and is safe to call from any concurrency context.
    @inlinable @discardableResult
    func asyncOrOptional(_ other: @Sendable () async -> Wrapped?) async -> Wrapped? {
        switch self {
        case .some: return self
        case .none: return await other()
        }
    }
}

// MARK: - Free Functions

/// Returns the first non-nil optional from a variadic list.
///
/// In Haskell terms this is `asum` from the Alternative typeclass.
///
/// ```swift
/// let a: Int? = nil
/// let b: Int? = nil
/// let c: Int? = 42
/// coalesce(a, b, c) // .some(42)
/// ```
///
/// - Parameter optionals: A variadic list of optionals.
/// - Returns: The first `.some` value, or `.none` if all are nil.
@inlinable public func coalesce<T>(_ optionals: T?...) -> T? {
    for optional in optionals {
        if let value = optional {
            return value
        }
    }
    return nil
}

/// Returns the first non-nil optional from an array.
///
/// ```swift
/// let values: [Int?] = [nil, nil, 42, 10]
/// coalesce(values) // .some(42)
/// ```
@inlinable public func coalesce<T>(_ optionals: [T?]) -> T? {
    for optional in optionals {
        if let value = optional {
            return value
        }
    }
    return nil
}
