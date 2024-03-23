
import Foundation

public extension Optional {

    /// **True** if optional instance is ````.none````.
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
    var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }


    /// **True** if optional instance is ````.some(Wrapped)````.
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
    var isSome: Bool { isNone == false }


    /// **True** if optional instance is ````.some(Wrapped)````.
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
    var isNotNone: Bool { isNone == false }


    /// **True** if optional instance is ````.none````.
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
    var isNotSome: Bool { isSome == false }
}
