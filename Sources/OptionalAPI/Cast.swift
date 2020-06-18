import UIKit

// MARK: - Free Function

public func cast<T>(_ otherType: T.Type) -> (Any) -> T? {
    return { thing in
        cast(thing, to: T.self)
    }
}

public func cast<T>(_ thing: Any, to: T.Type) -> T? {
    thing as? T
}

// MARK: - Extension

public extension Optional {
    func cast<T>(_ type: T.Type) -> T? {
        flatMap(
            OptionalAPI.cast(type)
        )
    }
}
