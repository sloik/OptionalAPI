import Foundation

// MARK: - Free Function


/// Curried version of `cast` function.
/// - Parameter otherType: Type to which to cast eg. `String.self`
/// - Returns: Function that expects an instance that will be _try_ to cast to the `T` type.
///
/// This form allows for easer composition. You provide configuration up
/// front and pass the instance later.
/// ```swift
/// let casterToCustomVC: (Any) -> CustomVC? = cast(CustomVC.self)
///
/// // later in code..
/// let someViewController: UIViewController? = ...
/// someViewController
///     .cast( CustomVC.self )
///     .andThen({ (vc: CustomVC) in
///         // work with a non optional instance of CustomVC
///     })
/// ```
public func cast<T>(_ otherType: T.Type = T.self) -> (Any) -> T? {
    return { thing in
        cast(thing, to: otherType)
    }
}


/// Free function wrapping Swift's conditional cast operator.
/// - Parameters:
///   - thing: Instance to be casted.
///   - to: Type to which to cast eg. `String.self`
/// - Returns: Some optional when cast succeeds or `none` otherwise.
public func cast<T>(_ thing: Any, to: T.Type = T.self) -> T? {
    thing as? T
}

// MARK: - Extension

public extension Optional {

    /// Cast.
    /// - Parameter type: Type to which to cast eg. `String.self`
    /// - Returns: Some optional when cast succeeds or `none` otherwise.
    ///
    /// This form allows for easer composition. You provide configuration up
    /// front and pass the instance later.
    /// ```swift
    /// let someViewController: UIViewController? = ...
    /// someViewController
    ///     .cast( CustomVC.self )
    ///     .andThen({ (vc: CustomVC) in
    ///     // work with a non optional instance of CustomVC
    ///     })
    /// ```
    func cast<T>(_ type: T.Type = T.self) -> T? {
        flatMap(
            OptionalAPI.cast(type)
        )
    }
}
