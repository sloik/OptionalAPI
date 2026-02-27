

/// Given a predicate returns a function that can be used for checking if given
/// optional wrapped value passes this predicate.
///
/// - Parameter predicate: Predicate that is applied to wrapped value of optional.
/// - Returns: Optional when wrapped value matches predicate or `.none`.
@inlinable @discardableResult
public func filter<W>(_ predicate: @escaping (W) -> Bool ) -> (W?) -> W? {
    return { (wrapped: W?) in
        wrapped.filter( predicate )
    }
}

public extension Optional {

    /// Operator used to filter out optionals that do not pass a predicate.
    /// ```swift
    /// let someNumber: Int? = ...
    ///
    /// someNumber
    ///     .filter{ $0 > 42 }
    ///     .andThen{ ... } // <-- here you have int's that are grater than 42
    /// ```
    /// - Parameter predicate: Predicate that should be applied to wrapped value.
    /// - Returns: Optional if it matches predicate or `.none`
    @inlinable @discardableResult
    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        switch map(predicate) {
        case true?: return self
        default   : return .none
        }
    }

    /// Asynchronous version of `filter` for async predicates.
    ///
    /// ```swift
    /// let value: Int? = 42
    /// let result = await value.asyncFilter { wrapped in
    ///     await Task.yield()
    ///     return wrapped > 41
    /// }
    /// ```
    ///
    /// - Parameter predicate: Async predicate applied to the wrapped value.
    /// - Returns: Optional if the predicate returns `true`, otherwise `.none`.
    @inlinable @discardableResult
    func asyncFilter(_ predicate: (Wrapped) async -> Bool) async -> Wrapped? {
        switch self {
        case .some(let wrapped):
            return await predicate(wrapped) ? self : .none
        case .none:
            return .none
        }
    }
}
