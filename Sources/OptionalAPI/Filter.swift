
import Foundation


/// Given a predicate returns a function that can be used for checking if given
/// optional wrapped value passes this predicate.
///
/// - Parameter predicate: Predicate that is applied to wrapped value of optional.
/// - Returns: Optional when wrapped value matches predicate or `.none`.
@discardableResult
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
    @discardableResult
    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        switch map(predicate) {
        case true?: return self
        default   : return .none
        }
    }
}
