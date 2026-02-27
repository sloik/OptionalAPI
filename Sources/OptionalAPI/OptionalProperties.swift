
public extension Optional {

    /// **True** if optional instance is none.
    ///
    /// Replaces a check for nil:
    ///
    /// ```swift
    /// let number: Int? = nil
    /// number == nil // true
    /// ```swift
    ///
    /// with more friendly:
    ///
    /// ```swift
    /// number.isNone // true
    /// ````
    @inlinable var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }


    /// **True** if optional instance is some.
    ///
    /// Replaces a check for nil:
    ///
    /// ```swift
    /// let number: Int? = .some(42)
    /// number != nil // true
    /// ````
    ///
    /// with more friendly:
    ///
    /// ```swift
    /// number.isSome // true
    /// ````
    @inlinable var isSome: Bool {
        switch self {
        case .some: return true
        case .none: return false
        }
    }


    /// **True** if optional instance is some.
    /// You can also read it as **isSome**.
    ///
    /// Replaces a check for nil:
    ///
    /// ```swift
    /// let number: Int? = .some(42)
    /// number != nil // true
    /// ````
    ///
    /// with more friendly:
    ///
    /// ```swift
    /// number.isNotNone // true
    /// ````
    @inlinable var isNotNone: Bool {
        switch self {
        case .some: return true
        case .none: return false
        }
    }


    /// **True** if optional instance is none.
    /// You can also read it as **isNone**.
    ///
    /// Replaces a check for nil:
    ///
    /// ```swift
    /// let number: Int? = nil
    /// number == nil // true
    /// ````
    ///
    /// with more friendly:
    ///
    /// ```swift
    /// number.isNotSome // true
    /// ````
    @inlinable var isNotSome: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
}
