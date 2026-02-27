
import AliasWonderland

public extension Optional {

     ///  `mapNone` is the same thing for `none` case like `andThen` for `some` case.
     ///
     ///  This functions allows you to `recover` from a computation that returned nil. It
     ///  ignores the some case and run only for `none`.
     ///
     ///  ```swift
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ (s: String) -> String? in nil }
     ///         // try to recover with home page
     ///         .mapNone("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com
     ///  ````
     ///
     ///  If the failing function would produce a valid output then `mapNone` would not be called.
     ///
     ///  ```swift
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ $0 + "page.html" }
     ///         // computation did not fail so nothing to recover from
     ///         .mapNone("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com/page.html
     ///  ```
     ///
     ///  You can `mapNone` more than once and on any stage you want.
    @inlinable @discardableResult
    func mapNone(_ producer: @autoclosure Producer<Wrapped>) -> Wrapped? {
        or(producer)
    }

    /// Asynchronous version of `mapNone` for producing fallback values.
    ///
    /// ```swift
    /// let value: Int? = nil
    /// let result = await value.asyncMapNone {
    ///     await Task.yield()
    ///     return 42
    /// }
    /// ```
    ///
    /// - Parameter producer: Async producer of the fallback value.
    /// - Returns: Original value for `.some`, otherwise the produced fallback.
    @inlinable @discardableResult
    func asyncMapNone(_ producer: () async -> Wrapped) async -> Wrapped? {
        switch self {
        case .some(let wrapped): return wrapped
        case .none             : return await producer()
        }
    }

     ///  `defaultSome` is just a better name than `mapNone`. Both work exactly the same.
     ///
     ///  This functions allows you to `recover` from a computation that returned nil. It
     ///  ignores the some case and run only for `none`.
     ///
     ///  ```swift
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ (s: String) -> String? in nil }
     ///         // try to recover with home page
     ///         .defaultSome("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com
     ///  ```
     ///
     ///  If the failing function would produce a valid output then `mapNone` would not be called.
     ///
     ///  ```swift
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ $0 + "page.html" }
     ///         // computation did not fail so nothing to recover from
     ///         .defaultSome("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com/page.html
     ///  ```
     ///
     ///  You can `defaultSome` more than once and on any stage you want.
    @inlinable @discardableResult
    func defaultSome(_ producer: @autoclosure Producer<Wrapped>) -> Wrapped? {
        or(producer)
    }

    /// Asynchronous version of `defaultSome` for producing fallback values.
    ///
    /// ```swift
    /// let value: Int? = nil
    /// let result = await value.asyncDefaultSome {
    ///     await Task.yield()
    ///     return 42
    /// }
    /// ```
    ///
    /// - Parameter producer: Async producer of the fallback value.
    /// - Returns: Original value for `.some`, otherwise the produced fallback.
    @inlinable @discardableResult
    func asyncDefaultSome(_ producer: () async -> Wrapped) async -> Wrapped? {
        switch self {
        case .some(let wrapped): return wrapped
        case .none             : return await producer()
        }
    }
}
