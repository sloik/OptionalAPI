// MARK: - Extension

public extension Optional {

    /// Applicative apply: applies a wrapped function to a wrapped value.
    ///
    /// In Haskell terms this is `<*>` from the Applicative typeclass.
    /// `Just f <*> Just x = Just (f x)`, otherwise `.none`.
    ///
    /// ```swift
    /// let increment: ((Int) -> Int)? = { $0 + 1 }
    /// let value: Int? = 41
    /// let result = increment.ap(value) // .some(42)
    ///
    /// let noFunction: ((Int) -> Int)? = nil
    /// noFunction.ap(value) // nil
    /// ```
    ///
    /// - Parameter wrappedValue: An optional value to apply the wrapped function to.
    /// - Returns: The result of applying the function to the value, or `.none`.
    @inlinable func ap<A, B>(_ wrappedValue: A?) -> B? where Wrapped == (A) -> B {
        switch self {
        case .some(let f):
            switch wrappedValue {
            case .some(let a): return f(a)
            case .none: return .none
            }
        case .none:
            return .none
        }
    }

    /// Async version of applicative apply.
    @inlinable func asyncAp<A, B>(_ wrappedValue: A?) async -> B? where Wrapped == (A) -> B {
        switch self {
        case .some(let f):
            switch wrappedValue {
            case .some(let a): return f(a)
            case .none: return .none
            }
        case .none:
            return .none
        }
    }
}

// MARK: - Free Functions

/// Applicative apply as a free function.
///
/// ```swift
/// let increment: ((Int) -> Int)? = { $0 + 1 }
/// let value: Int? = 41
/// ap(increment, value) // .some(42)
/// ```
@inlinable public func ap<A, B>(_ wrappedFunction: ((A) -> B)?, _ wrappedValue: A?) -> B? {
    wrappedFunction.ap(wrappedValue)
}

/// Curried version of applicative apply.
@inlinable public func ap<A, B>(_ wrappedFunction: ((A) -> B)?) -> (A?) -> B? {
    return { wrappedValue in
        wrappedFunction.ap(wrappedValue)
    }
}
