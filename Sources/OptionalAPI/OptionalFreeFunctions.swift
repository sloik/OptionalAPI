
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

// MARK: - or
@discardableResult
public func or<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T
{
    optional.or(producer)
}

@discardableResult
public func or<T>(
    _ producer: @autoclosure @escaping () -> T)
    -> (T?) -> T
{
    return { optional in
        optional.or(producer)
    }
}

@discardableResult
public func or<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T
{
    optional.or(producer)
}

@discardableResult
public func or<T>(
    _ producer: @escaping () -> T)
    -> (T?) -> T
{
    return { optional in
        optional.or(producer)
    }
}


// MARK: - mapNone
@discardableResult
public func mapNone<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.or(producer)
}

@discardableResult
public func mapNone<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T?
{
    optional.or(producer)
}

@discardableResult
public func mapNone<T>(
    _ producer: @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}

@discardableResult
public func mapNone<T>(
    _ producer: @escaping @autoclosure () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}


// MARK: - Default Some
public func defaultSome<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.or(producer)
}

public func defaultSome<T>(
    _ producer: @autoclosure @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}

public func defaultSome<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T? {
        optional.or(producer)
}

public func defaultSome<T>(
    _ producer: @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}

// MARK: - Collections

public func hasElements<T: Collection>(_ optional: T?) -> Bool {
    optional.hasElements
}

public func isNoneOrEmpty<T: Collection>(_ optional: T?) -> Bool {
    optional.isNoneOrEmpty
}

@discardableResult
public func recoverFromEmpty<T: Collection>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.recoverFromEmpty(producer)
}

@discardableResult
public func recoverFromEmpty<T: Collection>(
    _ producer: @autoclosure @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.recoverFromEmpty(producer)
    }
}

@discardableResult
public func recoverFromEmpty<T: Collection>(
    _ producer: @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.recoverFromEmpty(producer)
    }
}
