
import Foundation

public extension Optional {
    
    /// Operator used to filter out optionals that do not pass a predicate.
    /// ```
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
