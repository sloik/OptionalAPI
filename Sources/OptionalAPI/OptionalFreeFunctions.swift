
import Foundation

public func isNone<T>(_ optional: T?) -> Bool {
    optional.isNone
}

public func isSome<T>(_ optional: T?) -> Bool {
    optional.isSome
}

public func isNotNone<T>(_ optional: T?) -> Bool {
    optional.isNotNone
}

public func isNotSome<T>(_ optional: T?) -> Bool {
    optional.isNotSome
}


public func andThen<T, Wrapped>(
    _ optional: Wrapped?,
    _ transform: (Wrapped) -> T?)
    -> T?
{
    optional.andThen(transform)
}

public func andThen<T, Wrapped>(
    _ transform: @escaping (Wrapped) -> T?)
    -> (Wrapped?)
    -> T?
{
    return { optional in
        optional.andThen(transform)
    }
}


public func or<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T
{
    optional.or(producer)
}

public func or<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T
{
    optional.or(producer)
}


public func mapNone<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.or(producer)
}

public func mapNone<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T?
{
    optional.or(producer)
}


public func defaultSome<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.or(producer)
}

public func defaultSome<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T? {
        optional.or(producer)
}

// MARK: - Collections

public func hasElements<T: Collection>(_ optional: T?) -> Bool {
    optional.hasElements
}

public func isNoneOrEmpty<T: Collection>(_ optional: T?) -> Bool {
    optional.isNoneOrEmpty
}

public func recoverFromEmpty<T: Collection>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.recoverFromEmpty(producer)
}

public func recoverFromEmpty<T: Collection>(
    _ optional: T?,
    _ producer: () -> T)
    -> T?
{
    optional.recoverFromEmpty(producer)
}

