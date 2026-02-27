// MARK: - Free Functions

/// Wraps a value in `.some` only when the predicate returns `true`.
/// Returns `.none` when the predicate returns `false`.
///
/// ```swift
/// someWhen({ $0 > 18 }, 42) // .some(42)
/// someWhen({ $0 > 18 }, 10) // nil
/// ```
///
/// - Parameters:
///   - predicate: A predicate to test the value.
///   - value: The value to conditionally wrap.
/// - Returns: `.some(value)` if predicate passes, `.none` otherwise.
@inlinable public func someWhen<T>(_ predicate: (T) -> Bool, _ value: T) -> T? {
    predicate(value) ? value : nil
}

/// Curried version of `someWhen` for point-free composition.
///
/// ```swift
/// let adults: (Int) -> Int? = someWhen { $0 >= 18 }
/// adults(42) // .some(42)
/// adults(10) // nil
/// ```
@inlinable public func someWhen<T>(_ predicate: @escaping (T) -> Bool) -> (T) -> T? {
    return { value in
        someWhen(predicate, value)
    }
}

/// Wraps a value in `.some` only when the predicate returns `false`.
/// Returns `.none` when the predicate returns `true`.
///
/// The dual of `someWhen`.
///
/// ```swift
/// noneWhen({ $0 > 100 }, 42) // .some(42)
/// noneWhen({ $0 > 100 }, 200) // nil
/// ```
///
/// - Parameters:
///   - predicate: A predicate to test the value.
///   - value: The value to conditionally wrap.
/// - Returns: `.some(value)` if predicate fails, `.none` otherwise.
@inlinable public func noneWhen<T>(_ predicate: (T) -> Bool, _ value: T) -> T? {
    predicate(value) ? nil : value
}

/// Curried version of `noneWhen` for point-free composition.
///
/// ```swift
/// let notEmpty: (String) -> String? = noneWhen(\.isEmpty)
/// notEmpty("hello") // .some("hello")
/// notEmpty("") // nil
/// ```
@inlinable public func noneWhen<T>(_ predicate: @escaping (T) -> Bool) -> (T) -> T? {
    return { value in
        noneWhen(predicate, value)
    }
}
