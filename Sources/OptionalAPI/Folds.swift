
public extension Optional {

    @inlinable func fold<R>(
        _ noneCase: R,
        _ someCase: (Wrapped) -> R
    ) -> R {
        map( someCase ) ?? noneCase
    }

    /// Asynchronous version of `fold` for async transforms.
    ///
    /// ```swift
    /// let value: Int? = 42
    /// let result = await value.asyncFold(0) { wrapped in
    ///     await Task.yield()
    ///     return wrapped + 1
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - noneCase: Value returned when optional is `.none`.
    ///   - someCase: Async transform for the wrapped value.
    /// - Returns: Transformed value for `.some`, otherwise `noneCase`.
    /// - Note: The closure is `@Sendable` and is safe to call from any concurrency context.
    @inlinable func asyncFold<R>(
        _ noneCase: R,
        _ someCase: @Sendable (Wrapped) async -> R
    ) async -> R {
        switch self {
        case .some(let wrapped): return await someCase(wrapped)
        case .none             : return noneCase
        }
    }

}
