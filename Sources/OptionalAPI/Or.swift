
import Foundation

import AliasWonderland

public extension Optional {
    /// - Parameters:
    /// - producer: Value ot type `Wrapped` to be used in case of `.none`.
    ///
    /// `or` is a handy unwrapper of the wrapped value inside of optional **but** you must provide
    /// a `default` value in case the Optional is `nil`. That way it will always return
    /// a **not optional** instance to work with.
    ///
    /// ```swift
    /// let missingAge: Int? = nil
    /// let underAge  : Int? = 17
    /// let overAge   : Int? = 42
    ///
    /// func canBuyBeer(_ age: Int) -> Bool { age > 18 }
    ///
    /// missingAge.andThen(canBuyBeer).or(false) // false
    /// underAge  .andThen(canBuyBeer).or(false) // false
    /// overAge   .andThen(canBuyBeer).or(false) // true
    /// ````
    ///
    /// Each time the final result was a true `Bool` not an `Bool?`.
    ///
    /// - Note: You can use `.init` and static method available on type to:
    ///
    /// ```swift
    /// let noneInt: Int? = nil
    /// noneInt.or( .init() ) // 0
    /// noneInt.or( .zero   ) // 0
    ///
    /// let noneDouble: Double? = nil
    /// noneDouble.or( .init() ) // 0
    ///
    /// let defaults: UserDefaults? = nil
    /// defaults.or( .standard ) // custom or "standard"
    ///
    /// let view: UIView? = nil
    /// view.or( .init() )
    ///
    /// // or any other init ;)
    /// view.or( .init(frame: .zero) )
    ///
    /// // Collections
    /// let noneIntArray : [Int]? = .none
    /// noneIntArray.or( .init() ) // []
    ///
    /// let emptySomeString: String? = ""
    /// noneString.or( .init() ) // ""
    ///
    /// // Enums
    /// enum Either {
    ///     case left, right
    /// }
    /// let noneEither: Either? = nil
    /// noneEither.or(.right)
    /// ````
    @discardableResult
    func or(_ producer: @autoclosure Producer<Wrapped>) -> Wrapped {
        self.or(producer)
    }

    func or(_ producer: Producer<Wrapped>) -> Wrapped {
        self ?? producer()
    }
}
