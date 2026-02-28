
public extension Optional {

    /// Asynchronous map over an optional value.
    ///
    /// Applies `transform` to the wrapped value when `.some`, returning the result wrapped
    /// in an optional. Returns `.none` without calling `transform` when the optional is `.none`.
    ///
    /// ```swift
    /// let value: Int? = 21
    /// let result = await value.asyncMap { $0 * 2 } // .some(42)
    /// ```
    ///
    /// - Parameter transform: An async closure applied to the wrapped value.
    /// - Returns: The transformed value wrapped in an optional, or `.none`.
    /// - Note: The closure is `@Sendable` and is safe to call from any concurrency context.
    @inlinable @discardableResult
    func asyncMap<T>(_ transform: @Sendable (Wrapped) async -> T) async -> T? {
        switch self {
        case .some(let wrapped): return await transform(wrapped)
        case .none             : return .none
        }
    }

    /// Asynchronous map that converts a thrown error into `.none`.
    ///
    /// Applies `transform` to the wrapped value when `.some`. If the transform throws,
    /// the error propagates. Returns `.none` without calling `transform` when `.none`.
    ///
    /// ```swift
    /// let optionalValue: Int? = 42
    /// do {
    ///     let result = try await optionalValue.tryAsyncMap { value in
    ///         try await expensiveTransform(value)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    ///
    /// - Parameter transform: An async throwing closure applied to the wrapped value.
    /// - Returns: The transformed value wrapped in an optional, or `.none`.
    /// - Throws: Rethrows errors from `transform`.
    /// - Note: The closure is `@Sendable` and is safe to call from any concurrency context.
    @inlinable @discardableResult
    func tryAsyncMap<T>(_ transform: @Sendable (Wrapped) async throws -> T) async throws -> T? {
        switch self {
        case .some(let wrapped): return try await transform(wrapped)
        case .none             : return .none
        }
    }

    /// Asynchronous flatMap over an optional value.
    ///
    /// Applies `transform` to the wrapped value when `.some`, flattening the resulting
    /// optional. Returns `.none` without calling `transform` when the optional is `.none`.
    ///
    /// ```swift
    /// let value: Int? = 42
    /// let result = await value.asyncFlatMap { v -> Int? in
    ///     await Task.yield()
    ///     return v > 0 ? v : nil
    /// }
    /// ```
    ///
    /// - Parameter transform: An async closure returning an optional value.
    /// - Returns: The flattened result, or `.none`.
    /// - Note: The closure is `@Sendable` and is safe to call from any concurrency context.
    @inlinable @discardableResult
    func asyncFlatMap<T>(_ transform: @Sendable (Wrapped) async -> T?) async -> T? {
        switch self {
        case .some(let wrapped): return await transform(wrapped)
        case .none             : return .none
        }
    }

    /// Asynchronous flatMap that propagates thrown errors.
    ///
    /// Applies `transform` to the wrapped value when `.some`, flattening the result.
    /// Returns `.none` without calling `transform` when the optional is `.none`.
    ///
    /// ```swift
    /// let value: Int? = 42
    /// let result = try await value.tryAsyncFlatMap { v -> Int? in
    ///     try await validate(v)
    /// }
    /// ```
    ///
    /// - Parameter transform: An async throwing closure returning an optional value.
    /// - Returns: The flattened result, or `.none`.
    /// - Throws: Rethrows errors from `transform`.
    /// - Note: The closure is `@Sendable` and is safe to call from any concurrency context.
    @inlinable @discardableResult
    func tryAsyncFlatMap<T>(_ transform: @Sendable (Wrapped) async throws -> T?) async throws -> T? {
        switch self {
        case .some(let wrapped): return try await transform(wrapped)
        case .none             : return .none
        }
    }
}
