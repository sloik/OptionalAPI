
@inlinable public func isNone<T>(_ optional: T?) -> Bool {
    optional.isNone
}

@inlinable public func isSome<T>(_ optional: T?) -> Bool {
    optional.isSome
}

@inlinable public func isNotNone<T>(_ optional: T?) -> Bool {
    optional.isNotNone
}

@inlinable public func isNotSome<T>(_ optional: T?) -> Bool {
    optional.isNotSome
}


@inlinable public func andThen<T, Wrapped>(
    _ optional: Wrapped?,
    _ transform: (Wrapped) -> T?)
    -> T?
{
    optional.andThen(transform)
}

@inlinable public func andThen<T, Wrapped>(
    _ transform: @escaping (Wrapped) -> T?)
    -> (Wrapped?)
    -> T?
{
    return { optional in
        optional.andThen(transform)
    }
}

// MARK: - or
@inlinable @discardableResult
public func or<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T
{
    optional.or(producer)
}

@inlinable @discardableResult
public func or<T>(
    _ producer: @autoclosure @escaping () -> T)
    -> (T?) -> T
{
    return { optional in
        optional.or(producer)
    }
}

@inlinable @discardableResult
public func or<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T
{
    optional.or(producer)
}

@inlinable @discardableResult
public func or<T>(
    _ producer: @escaping () -> T)
    -> (T?) -> T
{
    return { optional in
        optional.or(producer)
    }
}


// MARK: - mapNone
@inlinable @discardableResult
public func mapNone<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.or(producer)
}

@inlinable @discardableResult
public func mapNone<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T?
{
    optional.or(producer)
}

@inlinable @discardableResult
public func mapNone<T>(
    _ producer: @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}

@inlinable @discardableResult
public func mapNone<T>(
    _ producer: @escaping @autoclosure () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}


// MARK: - Default Some
@inlinable public func defaultSome<T>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.or(producer)
}

@inlinable public func defaultSome<T>(
    _ producer: @autoclosure @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}

@inlinable public func defaultSome<T>(
    _ optional: T?,
    _ producer: () -> T)
    -> T? {
        optional.or(producer)
}

@inlinable public func defaultSome<T>(
    _ producer: @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.or(producer)
    }
}

// MARK: - Collections

@inlinable public func hasElements<T: Collection>(_ optional: T?) -> Bool {
    optional.hasElements
}

@inlinable public func isNoneOrEmpty<T: Collection>(_ optional: T?) -> Bool {
    optional.isNoneOrEmpty
}

@inlinable @discardableResult
public func recoverFromEmpty<T: Collection>(
    _ optional: T?,
    _ producer: @autoclosure () -> T)
    -> T?
{
    optional.recoverFromEmpty(producer)
}

@inlinable @discardableResult
public func recoverFromEmpty<T: Collection>(
    _ producer: @autoclosure @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.recoverFromEmpty(producer)
    }
}

@inlinable @discardableResult
public func recoverFromEmpty<T: Collection>(
    _ producer: @escaping () -> T)
    -> (T?) -> T?
{
    return { optional in
        optional.recoverFromEmpty(producer)
    }
}
